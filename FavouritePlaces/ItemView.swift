//
//  ItemView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI
import CoreData

/// ItemView is a SwiftUI view that allows the user to edit a list of items. It includes an EditView to display and edit the list's title, and a List that displays each item as a text and a checkmark circle. When an item is tapped, the checked state of the item is toggled. The user can delete or reorder items in the List, and add new items using a TextField and an Add button.
struct ItemView: View {
    /// The data model containing the list being edited
    @Binding var list: DataModel
    /// The index of the list being edited in the data model
    var count: Int

    /// The name of the list being edited
    @State var listName: String = ""
    /// The name of the new item being added to the list
    @State var url: String = ""
    /// The original list details before any changes were made
    @State var description: String = ""
    /// The current list details being edited
    @State var longitude: String = ""
    /// The state of the reset button (true if reset has been applied, false otherwise)
    @State var latitude: String = ""

    var body: some View {
        VStack {
            EditView(title: $listName)

            List {
                if let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                TextField("Name:", text: $listName)
                TextField("URL:", text: $url)
                TextField("Description:", text: $description)
                TextField("longitude:", text: $longitude)
                TextField("latitude:", text: $latitude)
            }
        }
        .navigationTitle("\(listName)")
        .navigationBarItems(
            trailing:
                HStack {
//                    Button(action: {
//                        list.save()
//                    }) {
//                        Text("Save")
//                    }
                    EditButton()
                }
        )
        .onAppear {
            // Update listName, originalListDet, and tempListDet when view appears
            listName = list.tasks[count].list
            url = list.tasks[count].url
            description = list.tasks[count].description
            longitude = list.tasks[count].longitude
            latitude = list.tasks[count].latitude
        }
        .onDisappear {
            // Update listName when view disappear
            list.tasks[count].list = listName
            list.tasks[count].url = url
            list.tasks[count].description = description
            list.tasks[count].longitude = longitude
            list.tasks[count].latitude = latitude
            list.save()
        }
    }
}
