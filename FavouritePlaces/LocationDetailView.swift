import SwiftUI
import MapKit

struct LocationDetailView: View {
    let location: AppData
    @Binding var model: DataModel

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    var body: some View {
        VStack {
            Text("Location Details")
                .font(.title)
                .padding()

            if let imageUrl = URL(string: location.url) {
                ImageView(url: imageUrl)
                    .frame(width: 100, height: 100)
            }

            Text("Name: \(location.list)")
                .padding()
            Text("Latitude: \(location.latitude)")
                .padding()
            Text("Longitude: \(location.longitude)")
                .padding()

            Map(coordinateRegion: $region, annotationItems: [location]) { item in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            }
            .frame(height: 300)
            .onAppear {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }

            Spacer()

            Button("Edit Coordinates") {
                if let index = model.tasks.firstIndex(where: { $0.list == location.list }) {
                    let updatedLocation = AppData(
                        list: location.list,
                        url: location.url,
                        description: location.description,
                        longitude: location.longitude,
                        latitude: location.latitude
                    )
                    model.tasks[index] = updatedLocation
                    model.save()
                }
            }
            .padding()
        }
    }
}
