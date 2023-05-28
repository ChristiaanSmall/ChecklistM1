import SwiftUI

struct ContentView: View {
    @Binding var model: DataModel
    @State var myTitle = "MyList"
    @State private var selectedLocation: AppData?

    var body: some View {
        NavigationView() {
            VStack {
                EditView(title: $myTitle)

                List {
                    ForEach(model.tasks.indices, id: \.self) { index in
                        NavigationLink(destination: ItemView(list: $model, count: index, selectedLocation: $selectedLocation)) {
                            let location = model.tasks[index]
                            if let imageUrl = URL(string: location.url) {
                                ImageView(url: imageUrl)
                                    .frame(width: 40, height: 40) // Setting the frame size
                            }
                            Text(location.list)
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
                    trailing: Button("+") {
                        model.tasks.append(AppData(list: "Siq List", url: "", description: "bruh", longitude: 0.0, latitude: 0.0))
                        model.save()
                    }
                )
            }
        }
        .padding()
        .sheet(item: $selectedLocation) { location in
            LocationDetailView(location: location, model: $model)
        }
    }
}
