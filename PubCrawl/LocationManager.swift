//
//  LocationManager.swift
//  MapIsGood
//
//  Created by Jacob Bartlett on 18/03/2025.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private var locationCallback: ((CLLocationCoordinate2D) -> Void)?
    
    var locationStream: AsyncStream<CLLocationCoordinate2D> {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            locationCallback = {
                continuation.yield($0)
            }
        }
    }
    
    override private init() {
        super.init()
        requestWhenInUseAuthorization()
        delegate = self
    }
    
    func start() {
        startUpdatingLocation()
    }
    
    func stop() {
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationCallback?(location.coordinate)
        }
    }
}
