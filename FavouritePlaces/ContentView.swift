//
//  ContentView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var model: DataModel
    @State var myTitle = "MyList"

    var body: some View {
        NavigationView() {
            VStack {
                EditView(title: $myTitle)
                
                List {
                    ForEach(model.tasks.indices, id: \.self) { index in
                        NavigationLink(destination: ItemView(list: $model, count: index)) {

                            if let imageUrl = URL(string: model.tasks[index].url) {
                                ImageView(url: imageUrl)
                                    .frame(width: 40, height: 40) // Setting the frame size
                            }
                            Text(model.tasks[index].list)
                        }
                    }
                    .onDelete { idx in
                        model.tasks.remove(atOffsets: idx)
                        model.save()
                    }
                    .onMove { source, destination in
                        model.tasks.move(fromOffsets: source, toOffset: destination)
                        model.save()
                    }
                }
                .navigationTitle(myTitle)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button("+"){
                        model.tasks.append(AppData(list: "Siq List", url: "", description: "bruh", longitude: 0.0, latitude: 0.0))
                        model.save()
                    }
                )
            }
        }
        .padding()
    }
}
