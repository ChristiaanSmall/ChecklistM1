//
//  DataModel.swift
//  FavouritePlaces
//
//  Created by Christiaan Small on 31/3/2023.
//

import Foundation
import CoreLocation

/// Define a struct `AppData` to represent the data for each list item
struct AppData: Hashable, Codable {
    var list: String
    var url: String
    var description: String
    var longitude: Double
    var latitude: Double
}

struct DataModel: Codable {
    var tasks: [AppData] // Array to hold the list of tasks
    init() {
        tasks = [] // Initialize with an empty array of tasks
        load() // Load data from file on initialization
    }
    
    /// Load data from file, or use fakeData if file is not found or cannot be decoded
    mutating func load() {
        guard let url = getFile(),
              let data = try? Data(contentsOf: url),
              let datamodel = try? JSONDecoder().decode(DataModel.self, from: data)
        else {
            self.tasks = fakeData
            return
        }
        self.tasks = datamodel.tasks
    }
    
    /// Save the current data model to file
    func save() {
        guard let url = getFile(),
              let data = try? JSONEncoder().encode(self)
        else {
            return
        }
        try? data.write(to: url)
    }
}
func getLocationCoordinates(for locationName: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(locationName) { placemarks, error in
        guard let placemark = placemarks?.first,
              let location = placemark.location else {
            completion(nil)
            return
        }
        
        let coordinates = location.coordinate
        completion(coordinates)
    }
}
func getLocationName(for latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        guard let placemark = placemarks?.first,
              let name = placemark.name else {
            completion(nil)
            return
        }
        
        completion(name)
    }
}

/// Helper function to get the file URL for storing data
func getFile() -> URL? {
    let filename = "mytasks.json"
    let fm = FileManager.default
    guard let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    return url.appendingPathComponent(filename)
}

/// Define some fake data for initial testing or fallback
var fakeData = [
    AppData(list: "Siq List", url: "https://www.searchenginejournal.com/wp-content/uploads/2022/06/image-search-1600-x-840-px-62c6dc4ff1eee-sej.png", description: "bruh", longitude: -27.470030, latitude: -27.470030),
    AppData(list: "Siq List", url: "www.google.com", description: "sah dude", longitude: -27.470030, latitude: -27.470030),
]
