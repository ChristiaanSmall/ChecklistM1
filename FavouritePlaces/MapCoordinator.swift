//
//  MapCoordinator.swift
//  FavouritePlaces
//
//  Created by Christiaan on 28/5/2023.
//

import Foundation
import SwiftUI
import MapKit
import Combine

class MapCoordinator: NSObject, ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    private var cancellables = Set<AnyCancellable>()

    func updateMapRegion(latitude: Double, longitude: Double) {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}
