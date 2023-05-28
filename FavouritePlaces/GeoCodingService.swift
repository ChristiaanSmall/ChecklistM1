//
//  GeoCodingService.swift
//  FavouritePlaces
//
//  Created by Christiaan on 28/5/2023.
//

import Foundation
import CoreLocation

class GeoCodingService {
    
    private let geoCoder = CLGeocoder()

    func getLocationName(from coordinate: CLLocationCoordinate2D, completion: @escaping (Result<String, Error>) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else if let placemark = placemarks?.first {
                let locationName = [placemark.locality, placemark.administrativeArea, placemark.country]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                completion(.success(locationName))
            }
        }
    }
    
    func getCoordinates(from locationName: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geoCoder.geocodeAddressString(locationName) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else if let coordinate = placemarks?.first?.location?.coordinate {
                completion(.success(coordinate))
            }
        }
    }
}
