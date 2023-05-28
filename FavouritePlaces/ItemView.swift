import SwiftUI

struct ItemView: View {
    @Binding var list: DataModel
    var count: Int
    @Binding var selectedLocation: AppData?

    @State private var listName: String = ""
    @State private var url: String = ""
    @State private var description: String = ""
    @State private var longitude: Double = 0.0
    @State private var latitude: Double = 0.0

    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        VStack {
            EditView(title: $listName)

            List {
                if let imageUrl = URL(string: url) {
                    ImageView(url: imageUrl)
                }

                TextField("Name:", text: $listName)
                TextField("URL:", text: $url)
                TextField("Description:", text: $description)
                TextField("Longitude:", value: $longitude, formatter: decimalFormatter)
                TextField("Latitude:", value: $latitude, formatter: decimalFormatter)
            }
            .onChange(of: longitude) { newValue in
                updateLocation()
            }
            .onChange(of: latitude) { newValue in
                updateLocation()
            }
            .navigationTitle("\(listName)")
            .navigationBarItems(
                trailing: EditButton()
            )
            .onAppear {
                let currentLocation = list.tasks[count]
                listName = currentLocation.list
                url = currentLocation.url
                description = currentLocation.description
                longitude = currentLocation.longitude
                latitude = currentLocation.latitude
            }
            .onDisappear {
                let updatedLocation = AppData(
                    id: list.tasks[count].id,
                    list: listName,
                    url: url,
                    description: description,
                    longitude: longitude,
                    latitude: latitude
                )
                list.tasks[count] = updatedLocation
                list.save()
            }
            .onTapGesture {
                selectedLocation = list.tasks[count]
            }
        }
    }

    private func updateLocation() {
        if let index = list.tasks.firstIndex(where: { $0.id == list.tasks[count].id }) {
            let updatedLocation = AppData(
                id: list.tasks[count].id,
                list: listName,
                url: url,
                description: description,
                longitude: longitude,
                latitude: latitude
            )
            list.tasks[index] = updatedLocation
        }
    }
}
