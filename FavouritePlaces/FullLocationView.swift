//
//  FullLocationView.swift
//  FavouritePlaces
//
//  Created by Christiaan on 28/5/2023.
//

import SwiftUI
import MapKit

/// A view for displaying and editing a full location.
struct FullLocationView: View {
    @Binding var list: DataModel
    @Binding var selectedItemIndex: Int?
    
    var count: Int
    
    // State variables to track changes made by the user
    @State private var editedTitle: String = ""
    @State private var editedListName: String = ""
    @State private var editedLatitude: Double = 0.0
    @State private var editedLongitude: Double = 0.0
    
    // State variables for displaying location information
    @State private var displayedLocationName: String = ""
    @State private var isEditing: Bool = false
    
    // Number formatter for decimal values
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // Default coordinate region
    private let defaultCoordinateRegion = MKCoordinateRegion()
    
    // State variable to wrap the coordinate region
    @State private var coordinateRegionWrapper: CoordinateRegionWrapper
    
    /// Initializes a new FullLocationView with the given parameters.
    /// - Parameters:
    ///   - list: The binding to the data model.
    ///   - selectedItemIndex: The binding to the index of the selected item.
    ///   - count: The count of the item.
    init(list: Binding<DataModel>, selectedItemIndex: Binding<Int?>, count: Int) {
        _list = list
        _selectedItemIndex = selectedItemIndex
        self.count = count
        
        // Initialize state variables with the values from the selected item
        let item = list.wrappedValue.tasks[count]
        _editedTitle = State(initialValue: item.list)
        _editedListName = State(initialValue: item.list)
        _editedLatitude = State(initialValue: item.latitude)
        _editedLongitude = State(initialValue: item.longitude)
        _coordinateRegionWrapper = State(initialValue: CoordinateRegionWrapper(region: defaultCoordinateRegion))
        
        // Create a coordinate region based on the latitude and longitude
        let center = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        _coordinateRegionWrapper = State(initialValue: CoordinateRegionWrapper(region: region))
    }
    
    var body: some View {
        VStack {
            if isEditing {
                TextField("Location Name", text: $editedListName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                Text(editedListName)
                    .font(.title)
                    .padding()
            }
            
            TextField("Latitude", value: $editedLatitude, formatter: decimalFormatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(!isEditing)
            
            TextField("Longitude", value: $editedLongitude, formatter: decimalFormatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(!isEditing)
            
            Text("Current Location: \(displayedLocationName)")
                .font(.headline)
                .padding()
            
            Map(coordinateRegion: $coordinateRegionWrapper.region)
                .frame(height: 300)
                .onAppear {
                    // Update the displayed location name when the view appears
                    getLocationName(for: editedLatitude, longitude: editedLongitude) { name in
                        displayedLocationName = name ?? ""
                    }
                }
                .onChange(of: coordinateRegionWrapper) { wrapper in
                    // Update the edited latitude and longitude when the map region changes
                    editedLatitude = wrapper.region.center.latitude
                    editedLongitude = wrapper.region.center.longitude
                }
        }
        .navigationBarItems(trailing: editButton)
        .onAppear {
            // Update the displayed location name when the view appears
            getLocationName(for: editedLatitude, longitude: editedLongitude) { name in
                displayedLocationName = name ?? ""
            }
        }
    }
    
    private var editButton: some View {
        Button(action: {
            isEditing.toggle()
            
            if !isEditing {
                getLocationCoordinates(for: editedListName) { coordinates in
                    guard let coordinates = coordinates else {
                        return
                    }
                    
                    editedLatitude = coordinates.latitude
                    editedLongitude = coordinates.longitude
                    
                    updateLocationData()
                    updateMapRegion()
                }
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
    
    private func updateLocationData() {
        let newItem = AppData(
            list: editedListName,
            url: list.tasks[count].url,
            description: list.tasks[count].description,
            longitude: editedLongitude,
            latitude: editedLatitude
        )
        
        list.tasks[count] = newItem
        list.save()
        selectedItemIndex = nil
    }
    
    private func updateMapRegion() {
        getLocationName(for: editedLatitude, longitude: editedLongitude) { name in
            displayedLocationName = name ?? ""
        }
    }
}

/// A wrapper struct to make CoordinateRegion conform to the Equatable protocol.
struct CoordinateRegionWrapper: Equatable {
    var region: MKCoordinateRegion
    
    static func == (lhs: CoordinateRegionWrapper, rhs: CoordinateRegionWrapper) -> Bool {
        return lhs.region.center.latitude == rhs.region.center.latitude &&
            lhs.region.center.longitude == rhs.region.center.longitude &&
            lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
            lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
