//
//  TripMdeol.swift
//  SayahatAI
//
//  Created by Beket Barlykov  on 16.06.2023.
//

import Foundation
import Moya


struct ActivityMapModel: Codable{
    let place_name: String
    let address: String
    let place_description: String
    let coordinates: [String:Float]
    let website: String
    let contact_number: String
    let rating: Float
    let rating_count: Int
    let activity_types: [String]
    let photo_ref: String
    let image_url: [String]
}

extension ActivityMapModel: Identifiable, Hashable{
    
    var id: String{
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher){
        return hasher.combine(id)
    }
    
    public static func == (lhs: ActivityMapModel, rhs: ActivityMapModel) -> Bool{
        return lhs.id == rhs.id
    }
}


extension DayPlanMapModel: Identifiable, Hashable{
    
    var id: String{
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher){
        return hasher.combine(id)
    }
    
    public static func == (lhs: DayPlanMapModel, rhs: DayPlanMapModel) -> Bool{
        return lhs.id == rhs.id
    }
}

struct DayPlanMapModel: Codable{
    let day_num: Int
    let city: String
    let activities: [ActivityMapModel]
}


struct TripMapModel:  Codable{
    let _id: String
    let trip_title: String
    let user_id: String
    let trip_tags: [String]
    let num_days: Int
    let trips: [DayPlanMapModel]
}

extension TripMapModel: Identifiable, Hashable{
    
    var id: String{
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher){
        return hasher.combine(id)
    }
    
    public static func == (lhs: TripMapModel, rhs: TripMapModel) -> Bool{
        return lhs.id == rhs.id
    }
}

struct Trips: Codable{
    let trips: [TripMapModel]
}




class TripsViewModel: ObservableObject{
    let provider = MoyaProvider<TripsService>()
    @Published var trips: [TripMapModel] = []
    @Published var isNeedFetching = true
    
    func fetchTrips(){
        provider.request(.getTrips(token: AppDataAPI.token)){
            result in
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    do{
                        let data = try response.map(Trips.self)
                        print("trips fetching successful")
                        self.trips = data.trips
                        AppDataAPI.trips = data.trips
                    }catch{
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }else{
                    print("Trips fetching failed. Response: \(response.statusCode)")
                }
            case .failure(let error):
                print("Error while fetching trips: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTrip(tripId: String){
        provider.request(.deleteTrip(token: AppDataAPI.token, tripId: tripId)){
            result in
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    do{
                        AppDataAPI.trips = AppDataAPI.trips.filter { $0._id != tripId }
                    }catch{
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }else{
                    print("Trip deleting failed. Response: \(response.statusCode)")
                }
            case .failure(let error):
                print("Error while deleting trip: \(error.localizedDescription)")
            }
        }
    }
}
