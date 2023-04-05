//
//  ItemView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI

struct ItemView: View {
    @Binding var list: AppData

    @State var listName: String = ""
    @State var newItem: String = ""
    @State var originalListDet: [[String]] = []
    @State var tempListDet: [[String]] = []

    var body: some View {
        VStack {
            EditView(title: $listName)
            List {
                ForEach($tempListDet, id: \.self) { $item in
                    HStack{
                        Text(item[0])
                        Spacer()
                        Image(systemName: item[1])
                    }


                }
                .onDelete { idx in
                    tempListDet.remove(atOffsets: idx)
                }
                .onMove { idx, i in
                    tempListDet.move(fromOffsets: idx, toOffset: i)
                }
            }
            HStack {
                TextField("Add item", text: $newItem)
                Button(action: {
                    tempListDet.append([newItem, "xmark.circle.fill"])
                    newItem = ""
                }) {
                    Text("Add")
                }
            }
        }
        .navigationTitle("\(listName)")
        .navigationBarItems(
            leading:
                Button(action: {
                    tempListDet = originalListDet
                }) {
                    Text("Reset")
                },
            trailing:
                HStack {
                    Button(action: {
                        list.listDet = tempListDet
                        originalListDet = tempListDet
                    }) {
                        Text("Save")
                    }
                    EditButton()
                }
        )
        .onAppear {
            listName = list.list
            originalListDet = list.listDet
            tempListDet = list.listDet
        }
        .onDisappear {
            list.list = listName
        }
    }
}

