//
//  ItemView.swift
//  FavouritePlaces
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit

/// ItemView is a detailed view for displaying and editing an individual item.
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
    @Binding var selectedItemIndex: Int?
    
    // Sunrise and sunset properties
    @State private var sunrise: String = ""
    @State private var sunset: String = ""
    @State private var isLoadingSunData = false
    
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
                TextField("Description:", text: $description)
                TextField("URL:", text: $url)

                HStack {
                    Text("Location:")
                        .font(.headline)
                    
                    Text(displayedLocationName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
                
                NavigationLink(destination: FullLocationView(list: $list, selectedItemIndex: $selectedItemIndex, count: count), tag: count, selection: $selectedItemIndex) {
                    HStack {
                        Text("View Full Location Information")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.trailing, 8)
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))))
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 8)
                
                HStack {
                    VStack {
                        Image(systemName: "sunrise.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.orange)
                        
                        Text(sunset)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "sunset.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.purple)
                        
                        Text(sunrise)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 8)
            }
            .listStyle(InsetGroupedListStyle()) // Optional: Apply an inset style to the list
        }
        .onChange(of: longitude) { newValue in
            updateMapRegion()
            fetchSunData()
        }
        .onChange(of: latitude) { newValue in
            updateMapRegion()
            fetchSunData()
        }
        .navigationTitle("\(listName)")
        .navigationBarItems(
            trailing: EditButton()
        )
        .onAppear {
            // Set initial values from the data model
            listName = list.tasks[count].list
            url = list.tasks[count].url
            description = list.tasks[count].description
            longitude = list.tasks[count].longitude
            latitude = list.tasks[count].latitude
            updateMapRegion()
            fetchSunData()
        }
        .onDisappear {
            // Save changes to the data model when the view disappears
            list.tasks[count].list = listName
            list.tasks[count].url = url
            list.tasks[count].description = description
            list.tasks[count].longitude = longitude
            list.tasks[count].latitude = latitude
            list.save()
        }
    }
    
    /// Update the displayed location name based on the latitude and longitude coordinates.
    private func updateMapRegion() {
        getLocationName(for: latitude, longitude: longitude) { name in
            displayedLocationName = name ?? ""
        }
    }
    
    /// Fetch sunrise and sunset data based on the latitude and longitude coordinates.
    private func fetchSunData() {
        isLoadingSunData = true
        
        let urlStr = "https://api.sunrisesunset.io/json?lat=\(latitude)&lng=\(longitude)&timezone=UTC"
        
        guard let url = URL(string: urlStr) else {
            isLoadingSunData = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                isLoadingSunData = false
            }
            
            if let error = error {
                print("Error fetching sunrise and sunset data: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SunDataResponse.self, from: data)
                    sunrise = response.results.sunrise
                    sunset = response.results.sunset
                } catch {
                    print("Error decoding sunrise and sunset data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

/// A struct representing the sunrise and sunset data received from the API.
struct SunDataResponse: Codable {
    let results: SunData
}

/// A struct representing the sunrise and sunset times.
struct SunData: Codable {
    let sunrise: String
    let sunset: String
}
