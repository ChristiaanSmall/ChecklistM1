//
//  DataModel.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 31/3/2023.
//

import Foundation

struct AppData: Hashable, Codable {
    var list: String
    var listDet: [[String]]
}

struct listData: Hashable, Codable {
    var item: String
    var status: String
}

struct DataModel: Codable {
    var tasks: [AppData]
    var lists: [listData]
    init() {
        tasks = []
        lists = []
        load()
    }
    
    mutating func load() {
        guard let url = getFile(),
              let data = try? Data(contentsOf: url),
              let datamodel = try? JSONDecoder().decode(DataModel.self, from: data)
        else {
            self.tasks = fakeData
            self.lists = fakeLData

            return
        }
        self.tasks = datamodel.tasks
        self.lists = datamodel.lists

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

func getFile() -> URL? {
    let filename = "mytasks.json"
    let fm = FileManager.default
    guard let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    return url.appendingPathComponent(filename)
}

var fakeLData = [
    listData(item: "Do homework", status: "checkmark.circle.fill"),
    listData(item: "Do laundry", status: "checkmark.circle.fill")
]

var fakeData = [
    AppData(list: "To Do", listDet: [["Do Work", "status lol"],["Do234 Work", "status234 lol"]]),
    AppData(list: "Done", listDet: [["Do Work", "status lol"]])
]


