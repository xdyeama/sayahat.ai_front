//
//  TripsService.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 11.07.2023.
//

import Foundation
import Moya


enum TripsService{
    case getTrips(token: String)
    case getTripsLocations(token: String)
    case generateTrip(token: String, trip_title: String, cities: String, numDays: Int,  travelPreferences: String)
    case deleteTrip(token: String, tripId: String)
    case editTrip(token: String, tripId: String, dayNum: Int, newCity: String, travelStyles: String)
}

extension TripsService: TargetType{
    
    var baseURL: URL {
        URL(string: "https://sayahatai-backend.onrender.com/trips")!
        
    }
    
    var method: Moya.Method {
        switch self{
        case .getTrips, .getTripsLocations:
            return .get
        case .generateTrip:
            return .post
        case .deleteTrip:
            return .delete
        case .editTrip:
            return .put
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .generateTrip(let token, _, _, _, _), .getTrips(let token), .getTripsLocations(let token), .deleteTrip(let token,  _), .editTrip(let token,  _,  _,  _, _):
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        }
    }
    
    
    var path: String{
        switch self{
        case .getTrips:
            return "/"
        case .getTripsLocations:
            return "/locations/"
        case .generateTrip:
            return "/generate"
        case .deleteTrip(_, let tripId):
            return "\(tripId)"
        case .editTrip(_, let tripId,_,_,_):
            return "\(tripId)"
        }
        
    }
    
    var task: Moya.Task {
        switch self{
        case .getTrips, .getTripsLocations, .deleteTrip:
            return .requestPlain
        case let .generateTrip(_, trip_title, cities, numDays,  travelPreferences):
            let bodyParams: [String: String] = [
                "trip_title": trip_title,
                "cities": cities,
                "num_days": String(numDays),
                "travel_style": travelPreferences
            ]
            return .requestJSONEncodable(bodyParams)
        case let .editTrip(_, _,dayNum, newCity, travelStyles):
            let bodyParams: [String: String] = [
                "num_day": String(dayNum),
                "new_city": newCity,
                "travel_style": travelStyles
            ]
            return .requestJSONEncodable(bodyParams)
        }
        
    }
    
}
