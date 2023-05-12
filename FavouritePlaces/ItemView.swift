//
//  ItemView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 4/4/2023.
//

import SwiftUI
import CoreData
import MapKit

struct ItemView: View {
    @Binding var list: DataModel
    var count: Int

    @State var listName: String = ""
    @State var url: String = ""
    @State var description: String = ""
    @State var longitude: Double = 0.0
    @State var latitude: Double = 0.0
    @State var region: MKCoordinateRegion = MKCoordinateRegion()

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
                TextField("Longitude:", value: $longitude, formatter: NumberFormatter())
                TextField("Latitude:", value: $latitude, formatter: NumberFormatter())
                
                Button(action: {
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                }) {
                    Text("Update Map")
                }
                
                Map(coordinateRegion: $region)
                    .frame(height: 300)
            }
        }
        .navigationTitle("\(listName)")
        .navigationBarItems(
            trailing: EditButton()
        )
        .onAppear {
            listName = list.tasks[count].list
            url = list.tasks[count].url
            description = list.tasks[count].description
            longitude = list.tasks[count].longitude
            latitude = list.tasks[count].latitude
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
        .onDisappear {
            list.tasks[count].list = listName
            list.tasks[count].url = url
            list.tasks[count].description = description
            list.tasks[count].longitude = longitude
            list.tasks[count].latitude = latitude
            list.save()
        }
    }
}
