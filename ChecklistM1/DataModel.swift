//
//  DataModel.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 31/3/2023.
//

import Foundation

struct AppData: Hashable {
    var item: String
    var status: String
}

struct DataModel {
    var tasks:[AppData]
}

var fakeData = [
    AppData(item: "Do homework", status: "checkmark.circle.fill"),
    AppData(item: "Do Not do homework", status: "checkmark.circle.fill")
    ]
