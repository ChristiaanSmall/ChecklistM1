//
//  ChecklistM1App.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI

@main
struct ChecklistM1App: App {
    @State var model:DataModel = DataModel()
    var body: some Scene {
        WindowGroup {
            ContentView(model: $model)
            
        }
    }
}
