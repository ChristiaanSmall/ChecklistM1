//
//  ChecklistM1App.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI

/// ChecklistM1App is the main entry point of the app. It includes a State property for the DataModel and a WindowGroup that displays the ContentView as the main view of the app.
@main
struct ChecklistM1App: App {
    @State var model: DataModel = DataModel()
    
    /// The body of the app's main scene.
    var body: some Scene {
        WindowGroup {
            ContentView(model: $model)
        }
    }
}
