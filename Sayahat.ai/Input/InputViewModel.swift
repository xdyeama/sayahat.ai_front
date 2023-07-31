//
//  InputModel.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 03.07.2023.
//

import Foundation
import Moya
import SwiftUI

func calculateNumDays(_ startDate: Date, _ endDate: Date) -> Int {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
    return dateComponents.day!
  }

struct GenerateTripResponse: Codable{
    let trip_id: String
}

class InputViewModel: ObservableObject{
    let provider = CustomMoyaProvider<TripsService>()
    @Published var tripTitle: String = ""
    @Published var cities: [CityCases] = []
    @Published var citiesString: String = ""
    @Published var numDays: Int = 1
    @Published var travelPreferences: [TravelPreference] = []
    @Published var isTripGenerated: Bool = false

    
    func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func addTravelPreference(travelPref: TravelPreference){
        !travelPreferences.contains(travelPref) ? travelPreferences.append(travelPref) : nil
        print(travelPreferences)
    }
    
    func removeTravelPreference(travelPref: TravelPreference){
        if let index = travelPreferences.firstIndex(of: travelPref){
            travelPreferences.remove(at: index)
        }
        print(travelPreferences)
    }
    
    func generateTrip(_ isRequestProcessed: Binding<Bool>, _ isRequestProcessing: Binding<Bool>,_ selectedTab: Binding<Tab>){
        isRequestProcessed.wrappedValue = false
        isRequestProcessing.wrappedValue = true
        let numDays = numDays
        let travelStyleString = travelPreferences.map { $0.rawValue}.joined(separator: ", ")
        print(citiesString, numDays, travelStyleString)
        provider.request(.generateTrip(token: AppDataAPI.token, trip_title: tripTitle, cities: citiesString, numDays: numDays, travelPreferences: travelStyleString)){
            result in
            switch result{
            case .success(let response):
                if response.statusCode == 201{
                    do{
                        print("Trip successfully generated")
                        let _ = try response.map(GenerateTripResponse.self)
                        selectedTab.wrappedValue = Tab.map
                        selectedTab.wrappedValue = Tab.bag
                        isRequestProcessed.wrappedValue = true
                        isRequestProcessing.wrappedValue = false
            
                    }catch{
                        print("Error decoding generate Trip JSON: \(error.localizedDescription)")
                        selectedTab.wrappedValue = Tab.map
                        selectedTab.wrappedValue = Tab.bag

                        isRequestProcessed.wrappedValue = true
                        isRequestProcessing.wrappedValue = false
                    }
                }
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                isRequestProcessed.wrappedValue = true
                selectedTab.wrappedValue = Tab.map


            }
        }
    }
}
