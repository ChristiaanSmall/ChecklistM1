//
//  DataModel.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 31/3/2023.
//

import Foundation

struct AppData: Hashable, Codable{
    var item: String
    var status: String
}
func getFile() -> URL? {
    let filename = "mytasks.json"
    let fm = FileManager.default
    guard let url = fm.urls(for: .documentDirectory, in:
        FileManager.SearchPathDomainMask.userDomainMask)
        .first else {
        return nil
    }
    return url.appendingPathComponent(filename)
}
struct DataModel: Codable {
    var tasks:[AppData]
    init () {
        tasks = []
        load()
    }
    
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
    func save() {
        guard let url = getFile(),
              let data = try? JSONEncoder().encode(self)
        else {
            return
        }
        try? data.write(to: url)
    }
}

var fakeData = [
    AppData(item: "Do homework", status: "checkmark.circle.fill"),
    AppData(item: "Do Not do homework", status: "checkmark.circle.fill")
    ]
