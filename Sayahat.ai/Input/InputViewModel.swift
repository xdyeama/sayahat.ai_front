//
//  InputModel.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 03.07.2023.
//

import Foundation
import Moya
import SwiftUI



class InputViewModel: ObservableObject{
    let provider = CustomMoyaProvider<TripsService>()
    @Published var tripTitle: String = ""
    @Published var cities: [CityCases] = []
    @Published var citiesString: String = ""
    @Published var numDays: Int = 1
    @Published var travelPreferences: [TravelPreference] = []
    @Published var isTripGenerated: Bool = false
    @Published var isRequestProcessing: Bool = false
    @Published var isRequestProcessed: Bool = false

    
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
        self.isRequestProcessing = true
        let numDays = numDays
        let travelStyleString = travelPreferences.map { $0.rawValue}.joined(separator: ", ")
        print(citiesString, numDays, travelStyleString)
        provider.request(.generateTrip(token: AppDataAPI.token, trip_title: tripTitle, cities: citiesString, numDays: numDays, travelPreferences: travelStyleString)){
            result in
            switch result{
            case .success(let response):
                if response.statusCode == 201{
                    do{
                        self.isRequestProcessed = true
//                        self.isRequestProcessing = false
//                        self.isRequestProcessed = true
                        print("Trip successfully generated")
                    }catch{
                        print("Error decoding generate Trip JSON: \(error.localizedDescription)")
                        self.isRequestProcessing = false
//                        self.isRequestProcessed = true

                    }
                }
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                self.isRequestProcessing = false
                selectedTab.wrappedValue = Tab.newspaper


            }
        }
    }
}
