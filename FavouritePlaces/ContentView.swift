//
//  ContentView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI


struct ContentView: View {
    
    /// A binding to a data model that holds the list of tasks.
    @Binding var model: DataModel
    
    /// The title of the list.
    @State var myTitle = "MyList"
    
    /// The body of the view.
    var body: some View {
        
        NavigationView() {
            VStack {
                
                // Add an EditView to the top of the screen.
                EditView(title: $myTitle)
                
                // Create a List of tasks using a ForEach loop.
                List {
                    ForEach(model.tasks.indices, id: \.self) { index in
                        
                        // Add a NavigationLink for each task in the list.
                        NavigationLink(destination: ItemView(list: $model, count: index)) {
                            if let imageUrl = URL(string: model.tasks[index].url), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            Text(model.tasks[index].list)
                        }
                    }
                    // Enable deletion of tasks from the list
                    .onDelete { idx in
                        model.tasks.remove(atOffsets: idx)
                        model.save()
                    }
                    // Enable reordering of tasks in the list.
                    .onMove { source, destination in
                        model.tasks.move(fromOffsets: source, toOffset: destination)
                        model.save()
                    }
                }
                .navigationTitle(myTitle)
                .navigationBarItems(
                    leading: EditButton(),
                    
                    // Add a button to create a new task in the list.
                    trailing: Button("+"){
                        model.tasks.append(AppData(list: "Siq List", url: "", description: "bruh", longitude: "0", latitude: "0"))
                        model.save()
                    }
                )
            }
        }
        .padding()
    }
}
