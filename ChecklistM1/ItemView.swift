//
//  ItemView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI
/// ItemView is a SwiftUI view that allows the user to edit a list of items. It includes an EditView to display and edit the list's title, and a List that displays each item as a text and a checkmark circle. When an item is tapped, the checked state of the item is toggled. The user can delete or reorder items in the List, and add new items using a TextField and an Add button.
struct ItemView: View {
    /// The data model containing the list being edited
    @Binding var list: DataModel
    /// The index of the list being edited in the data model
    var count: Int

    /// The name of the list being edited
    @State var listName: String = ""
    /// The name of the new item being added to the list
    @State var newItem: String = ""
    /// The original list details before any changes were made
    @State var originalListDet: [[String]] = []
    /// The current list details being edited
    @State var tempListDet: [[String]] = []
    /// The state of the reset button (true if reset has been applied, false otherwise)
    @State var isReset: Bool = false

    var body: some View {
        VStack {
            EditView(title: $listName)

            List {
                ForEach($tempListDet, id: \.self) { $item in
                    HStack{
                        //Adds text items
                        Text(item[0])
                        Spacer()
                        Image(systemName: item[1])
                    }
                    .onTapGesture {
                        // Toggle the checked state of the item when tapped
                        if item[1] == "checkmark.circle.fill" {
                            item[1] = "circle"
                        } else {
                            item[1] = "checkmark.circle.fill"
                        }
                    }
                }
                .onDelete { idx in
                    // Delete item at specified index from tempListDet
                    tempListDet.remove(atOffsets: idx)
                }
                .onMove { idx, i in
                    // Move item from one index to another in tempListDet
                    tempListDet.move(fromOffsets: idx, toOffset: i)
                }

                HStack {
                    // TextField for adding a new item
                    TextField("Add item", text: $newItem)
                    Button(action: {
                        // Append new item to tempListDet when Add button is tapped
                        tempListDet.append([newItem, "circle"])
                        newItem = ""
                    }) {
                        Text("Add")
                    }
                }
            }
        }
        .navigationTitle("\(listName)")
        .navigationBarItems(
            leading:
                Button(action: {
                    // Reset tempListDet to originalListDet when Reset button is tapped
                    if isReset {
                        tempListDet = originalListDet
                        isReset.toggle()
                    } else {
                        originalListDet = tempListDet
                        tempListDet = tempListDet.map{ [$0[0], "circle"] } // reset all items to circle
                        isReset.toggle()
                    }
                }) {
                    Text(isReset ? "Go back" : "Reset") // toggle button text based on state
                },
            trailing:
                HStack {
                    Button(action: {
                        // Update list tasks with changes in tempListDet and save to DataModel
                        list.tasks[count].listDet = tempListDet
                        originalListDet = tempListDet
                        list.save()
                    }) {
                        Text("Save")
                    }
                    EditButton()
                }
        )
        .onAppear {
            // Update listName, originalListDet, and tempListDet when view appears
            listName = list.tasks[count].list
            originalListDet = list.tasks[count].listDet
            tempListDet = list.tasks[count].listDet
        }
        .onDisappear {
            // Update listName when view disappears
            list.tasks[count].list = listName
        }
    }
}
