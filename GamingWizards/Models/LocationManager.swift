//
//  LocationManager.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/24/23.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private var locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    var locationCompletion: ((Double?, Double?, String?, String?) -> Void)?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
    }
    
    func requestUserLocation(completion: @escaping (Double?, Double?, String?, String?) -> Void) {
        locationCompletion = completion
        locationManager.requestWhenInUseAuthorization() // You can customize this based on your app's requirements
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, err in
                if let error = err {
                    print("ERROR WITH REVERSE GEOCODE LOCATION: \(error.localizedDescription)")
                    return
                }
                var city: String?
                var state: String?
                if let placemark = placemarks?.first {
                    city = placemark.locality
                    state = placemark.administrativeArea
                }
                self.locationCompletion?(self.location?.latitude, self.location?.longitude, city, state)
                self.locationCompletion = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR, LOCATION UPDATE FAILED WITH ERROR: \(error.localizedDescription)")
        locationCompletion?(nil, nil, nil, nil)
        locationCompletion = nil
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
}


/*
final class LocationModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @State private var location: CLLocationCoordinate2D?
    @State private var locationString: String = ""

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    public func requestAuthorization(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            self.location = location
            locationString = "Lat: \(location.latitude), Lon: \(location.longitude)"
            
            // Save to UserDefaults
            UserDefaults.standard.set(location.latitude, forKey: "latitude")
            UserDefaults.standard.set(location.longitude, forKey: "longitude")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
}

extension LocationModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
}
*/
