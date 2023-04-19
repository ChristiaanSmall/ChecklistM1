//
//  DataModel.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 31/3/2023.
//

import Foundation

/// Define a struct `AppData` to represent the data for each list item
/// It conforms to Hashable and Codable protocols for encoding and decoding
struct AppData: Hashable, Codable {
    var list: String
    var listDet: [[String]]
}

/// DataModel is a class that conforms to the ObservableObject protocol. It holds an array of AppData objects and provides methods for adding, deleting, and updating these objects. It also includes a method to load the data from a JSON file and save the data to the same file when changes are made.
/// Define the main data model struct `DataModel` for the app
/// It conforms to Codable protocol for encoding and decoding
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
    AppData(list: "To Do", listDet: [["Do Work", "circle"],["Do Nothing", "checkmark.circle.fill"]]),
    AppData(list: "Cool List", listDet: [["Do Work", "circle"]])
]
