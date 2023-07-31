//
//  MapStructs.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 19.07.2023.
//

import Foundation
import MapKit


struct Location: Identifiable, Equatable{
    var id: String{
        name + cityName
    }
    
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    
    init(mapLocation: LocationFetch) {
            name = mapLocation.place_name
            cityName = mapLocation.city
            coordinates = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(mapLocation.coordinates?["lat"] ?? 48.0196),
                longitude: CLLocationDegrees(mapLocation.coordinates?["lng"] ?? 66.9237)
            )
            description = mapLocation.description
            imageNames = mapLocation.image_url
        if let webLink = mapLocation.website{
            link = webLink
        }else{
            link = ""
        }
        }
    init(userLocation: CLLocation){
        name = "User"
        cityName = ""
        coordinates = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        description = ""
        imageNames = []
        link = ""
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LocationFetch: Codable{
//    var id: String = UUID().uuidString

    let place_name: String
    let city: String
    let description: String
    let image_url: [String]
    let website: String?
    let coordinates: [String: Double]?

}

extension LocationFetch: Identifiable, Hashable{
    var id: String{
        place_name + city
    }
    
    public func hash(into hasher: inout Hasher){
        return hasher.combine(id)
    }
    
    static func == (lhs: LocationFetch, rhs: LocationFetch) -> Bool {
        return lhs.id == rhs.id
    }
}

struct TripFetch: Codable{
    let trip_title: String
    let locations: [LocationFetch]
}

extension TripFetch: Identifiable, Hashable{
    var id: String{
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher){
        return hasher.combine(id)
    }
    
    public static func == (lhs: TripFetch, rhs: TripFetch) -> Bool{
        return lhs.id == rhs.id
    }
    
}

struct TripsFetch: Codable{
    let trips: [TripFetch]
}

struct TripMap: Identifiable, Equatable{
    var id: String = UUID().uuidString
    let trip_title: String
    let locations: [Location]
    
    public func hash(into hasher: inout Hasher){
        return hasher.combine(id)
    }
    
    public static func == (lhs: TripMap, rhs: TripMap) -> Bool{
        return lhs.id == rhs.id
    }
}

