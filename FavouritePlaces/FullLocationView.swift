//
//  MapCoordinator.swift
//  FavouritePlaces
//
//  Created by Christiaan on 28/5/2023.
//

import SwiftUI
import MapKit

struct FullLocationView: View {
    @Binding var list: DataModel
    @Binding var selectedItemIndex: Int?

    var count: Int
    
    @State private var editedTitle: String = ""
    @State private var editedListName: String = ""
    @State private var editedLatitude: Double = 0.0
    @State private var editedLongitude: Double = 0.0
    
    @State private var displayedLocationName: String = ""
    @State private var isEditing: Bool = false
    
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private let defaultCoordinateRegion = MKCoordinateRegion()
    @State private var coordinateRegionWrapper: CoordinateRegionWrapper
    
    init(list: Binding<DataModel>, selectedItemIndex: Binding<Int?>, count: Int) {
        _list = list
        _selectedItemIndex = selectedItemIndex
        self.count = count
        
        let item = list.wrappedValue.tasks[count]
        _editedTitle = State(initialValue: item.list)
        _editedListName = State(initialValue: item.list)
        _editedLatitude = State(initialValue: item.latitude)
        _editedLongitude = State(initialValue: item.longitude)
        _coordinateRegionWrapper = State(initialValue: CoordinateRegionWrapper(region: defaultCoordinateRegion))
        
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
                    getLocationName(for: editedLatitude, longitude: editedLongitude) { name in
                        displayedLocationName = name ?? ""
                    }
                }
                .onChange(of: coordinateRegionWrapper) { wrapper in
                    editedLatitude = wrapper.region.center.latitude
                    editedLongitude = wrapper.region.center.longitude
                }
        }
        .navigationBarItems(trailing: editButton)
        .onAppear {
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
