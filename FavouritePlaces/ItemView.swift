//
//  ItemView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct ItemView: View {
    @Binding var list: DataModel
    var count: Int
    @State var listName: String = ""
    @State var url: String = ""
    @State var description: String = ""
    @State var longitude: Double = 0.0
    @State var latitude: Double = 0.0
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    @State private var displayedLocationName: String = ""

    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            EditView(title: $listName)
            
            List {
                if let imageUrl = URL(string: url) {
                    ImageView(url: imageUrl)
                }
                
                TextField("Name:", text: $listName)
                TextField("URL:", text: $url)
                TextField("Description:", text: $description)
                TextField("Longitude:", value: $longitude, formatter: decimalFormatter)
                TextField("Latitude:", value: $latitude, formatter: decimalFormatter)
                Button("Get Coordinates") {
                    getLocationCoordinates(for: listName) { coordinates in
                        guard let coordinates = coordinates else {
                            // Handle case when coordinates are not found for the given location name
                            return
                        }
                        
                        // Update the latitude and longitude properties with the retrieved coordinates
                        latitude = coordinates.latitude
                        longitude = coordinates.longitude
                        
                        // Update the map region to reflect the new coordinates
                        updateMapRegion()
                    }
                }
                Text("Location: \(displayedLocationName)")
                    .font(.headline)
                
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
                    .frame(height: 300)

                
            }
        }
        .onChange(of: longitude) { newValue in
            updateMapRegion()
        }
        .onChange(of: latitude) { newValue in
            updateMapRegion()
        }
        .navigationTitle("\(listName)")
        .navigationBarItems(
            trailing: EditButton()
        )
        .onAppear {
            getLocationName(for: latitude, longitude: longitude) { name in
                displayedLocationName = name ?? ""
            }
            listName = list.tasks[count].list
            url = list.tasks[count].url
            description = list.tasks[count].description
            longitude = list.tasks[count].longitude
            latitude = list.tasks[count].latitude
            updateMapRegion()
        }
        .onDisappear {
            list.tasks[count].list = listName
            list.tasks[count].url = url
            list.tasks[count].description = description
            list.tasks[count].longitude = longitude
            list.tasks[count].latitude = latitude
            list.save()
        }
    }
    
    private func updateMapRegion() {
        getLocationName(for: latitude, longitude: longitude) { name in
            displayedLocationName = name ?? ""
        }
    }



}
