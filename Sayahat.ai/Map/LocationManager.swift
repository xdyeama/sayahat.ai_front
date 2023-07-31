//
//  LocationManager.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 19.07.2023.
//

import Foundation
import CoreLocation



class LocationManager: CLLocationManager, ObservableObject{
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status{
            case .notDetermined:
                print("DEBUG: NotDetermined")
            case .restricted:
                print("DEBUG: Restricted")
            case .denied:
                print("DEBUG: DENIED)")
            case .authorizedAlways:
                print("DEBUG: AuthorizedAlways")
            case .authorizedWhenInUse:
                print("DEBUG: AutorizedWhenInUse")
            @unknown default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}


