//
//  ItemView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI

struct ItemView: View {
    @Binding var list: AppData
    @AppStorage("checklist_data") var checklistData: Data?

    @State var listName: String = ""
    @State var newItem: String = ""
    @State var originalListDet: [[String]] = []
    @State var tempListDet: [[String]] = []

    var body: some View {
        VStack {
            EditView(title: $listName)

            List {
                ForEach($tempListDet, id: \.self) { $item in
                    Text(item[0])
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
                    tempListDet.append([newItem])
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
                        saveData()
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
            loadData()
        }
        .onDisappear {
            list.list = listName
        }
    }

    func saveData() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            checklistData = data
        } catch {
            print("Error encoding checklist data: \(error.localizedDescription)")
        }
    }

    func loadData() {
        guard let data = checklistData else { return }
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(AppData.self, from: data)
            list = decodedData
            originalListDet = decodedData.listDet
            tempListDet = decodedData.listDet
        } catch {
            print("Error decoding checklist data: \(error.localizedDescription)")
        }
    }
}
