//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Christiaan Small on 23/5/2023.
//

import SwiftUI
import MapKit

/// ContentView is the main view of the app, displaying a list of favorite places.
struct ContentView: View {
    @Binding var model: DataModel
    @State var myTitle = "MyList"
    @State private var selectedItemIndex: Int?

    var body: some View {
        NavigationView {
            VStack {
                // EditView for modifying the title of the list
                EditView(title: $myTitle)
                
                List {
                    ForEach(model.tasks.indices, id: \.self) { index in
                        // NavigationLink to navigate to the detailed view of an item
                        NavigationLink(destination: ItemView(list: $model, count: index, selectedItemIndex: $selectedItemIndex)) {
                            VStack(alignment: .leading) {
                                // Display an image associated with the item if available
                                if let imageUrl = URL(string: model.tasks[index].url) {
                                    ImageView(url: imageUrl)
                                        .frame(width: 40, height: 40)
                                }
                                
                                // Display the title of the item
                                Text(model.tasks[index].list)
                                    .font(.headline)
                            }
                        }
                    }
                    .onDelete { idx in
                        // Handle deletion of an item from the list
                        model.tasks.remove(atOffsets: idx)
                        model.save()
                        selectedItemIndex = nil // Reset the selectedItemIndex after deletion
                    }

                    .onMove { source, destination in
                        // Handle reordering of items in the list
                        model.tasks.move(fromOffsets: source, toOffset: destination)
                        model.save()
                    }
                }
                .navigationTitle(myTitle)
                .navigationBarItems(
                    leading: EditButton(), // Standard EditButton for enabling editing mode
                    trailing: Button("+") {
                        // Button for adding a new item to the list
                        model.tasks.append(AppData(list: "Siq List", url: "", description: "bruh", longitude: 0.0, latitude: 0.0))
                        model.save()
                    }
                )
            }
        }
        .padding()
    }
}
