//
//  ItemView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI

struct ItemView: View {
    @Binding var list: DataModel
    var count: Int

    @State var listName: String = ""
    @State var newItem: String = ""
    @State var originalListDet: [[String]] = []
    @State var tempListDet: [[String]] = []
    @State var isReset: Bool = false // added state to track reset button state

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
