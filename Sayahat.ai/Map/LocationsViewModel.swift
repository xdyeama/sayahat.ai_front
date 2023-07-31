//
//  LocationsViewModel.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 16.07.2023.
//

import Foundation
import MapKit
import SwiftUI
import Moya
import CoreLocation



class LocationsViewModel: ObservableObject{
    let provider: MoyaProvider = MoyaProvider<TripsService>()
    // All Loaded Locations
    @Published var trips: [TripMap] = []
    @Published var locations: [Location] = [Location(mapLocation: LocationFetch(place_name: "", city: "", description: "", image_url: [], website: "", coordinates: ["lat": 48.0196, "lng": 66.9237]))]
    
    // Current region on map
    @Published var currMapLocation: Location {
        // if we change the value of currmapLocation, updateMapRegion function will be automatically executed
        
        didSet {
            mapRegion = MKCoordinateRegion(center: currMapLocation.coordinates, span: mapSpan)
        }
    }
    @Published var currTrip: TripMap = TripMap(trip_title: "", locations: [])
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    // Variable to identify when to show the list of locations
    @Published var showLocationsList: Bool = false
    
    // Variable to show location detail via sheet
    @Published var sheetLocation: Location? = nil
    @Published var locationManager = LocationManager.shared
    
    init(){
        self.trips = []
        self.locations = [Location(mapLocation: LocationFetch(place_name: "Kazakhstan", city: "", description: "", image_url: [], website: "", coordinates: ["lat": 48.0196, "lng": 66.9237]))]
        self.currMapLocation = Location(mapLocation: LocationFetch(place_name: "Kazakhstan", city: "", description: "", image_url: [], website: "", coordinates: ["lat": 43.2428539, "lng": 76.9479289]))
        self.mapRegion = MKCoordinateRegion(center: self.currMapLocation.coordinates, span: mapSpan)

        self.currTrip = TripMap(trip_title: "", locations: [])
    }
    
    
    
    func toggleShowLocationsList(){
        withAnimation(.easeInOut){
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(nextLocation: Location){
        withAnimation(.easeInOut) {
            currMapLocation = nextLocation
            showLocationsList = false
        }
    }
    
    func showNextTrip(nextTrip: TripMap){
        withAnimation(.easeInOut){
            currTrip = nextTrip
            locations = nextTrip.locations
            if let nextLocation = nextTrip.locations.first{
                showNextLocation(nextLocation: nextLocation)
            }
            showLocationsList = false
            
        }
    }
    
    
    fileprivate func extractedFunc(_ nextLocation: Location) {
        showNextLocation(nextLocation: nextLocation)
    }
    
    func nextButtonPressed(){
        // Get the index of current location
        guard let currIndex = locations.firstIndex(of: currMapLocation) else {
            print("Could not find the current index in the locations array. Should not ever happen")
            return
        }
        
        // Check if the current index is valid
        let nextIndex = currIndex + 1
        guard locations.indices.contains(nextIndex) else {
            // next index is not valid, restart from 0
            guard let firstLocation = locations.first else { return }
            showNextLocation(nextLocation: firstLocation)
            return
        }
        
        // next index is valid
        let nextLocation = locations[nextIndex]
        extractedFunc(nextLocation)
    }
    
    func fetchLocations(){
        provider.request(.getTripsLocations(token: AppDataAPI.token)){ [weak self]
            result in
            guard let self else { return }
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    do{
                        let data = try response.map(TripsFetch.self)
                        let fetchedTrips = data.trips
                        let mappedTrips = fetchedTrips.map(self.convertFetchedTrip)
                        self.trips = mappedTrips
                        if let trip = mappedTrips.first {
                            self.currTrip = trip
                            self.locations = trip.locations
                        }
                        if let location = self.locations.first {
                            self.currMapLocation = location
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error while fetching locations: \(error.localizedDescription)")
            }
        }
    }
    
    func convertFetchedLocations(_ mapLocations: [LocationFetch]) -> [Location] {
        return mapLocations.map { Location(mapLocation: $0) }
    }
    
    func convertFetchedTrip(_ fetchedTrip: TripFetch) -> TripMap {
        let locations = convertFetchedLocations(fetchedTrip.locations)
        return TripMap(trip_title: fetchedTrip.trip_title, locations: locations)
    }
    
    func calculateRoute(destinationCoordinates: CLLocationCoordinate2D) {
        
        if let sourceLocation = locationManager.userLocation{
            let destinationLocation = destinationCoordinates// Replace with destination coordinates
        
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation.coordinate)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
        
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                return
            }
            
            self.mapRegion = MKCoordinateRegion(route.polyline.boundingMapRect)
        }
    }
}
}
