//
//  AppDataLocalAPI.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 05.07.2023.
//

import Foundation


struct AppDataAPI{
    @AppDataStorage(key: "isOnboarding", defaultValue: true)
    static var isOnboarding: Bool
    
    @AppDataStorage(key: "isLoggedIn", defaultValue: false)
    static var isLoggedIn: Bool
    
    @AppDataStorage(key: "token", defaultValue: "")
    static var token: String
    
    @AppDataStorage(key: "trips", defaultValue: [])
    static var trips: [TripMapModel]
    

}

@propertyWrapper
struct AppDataStorage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = try? UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }

        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
