//
//  AuthorizationService.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 12.07.2023.
//

import Foundation
import Moya


enum AuthorizationService{
    case registerUser(email: String, password: String)
    case authorizeUser(email: String, password: String)
    case getMyAccount(token: String)
    case deleteUser(token: String)
    case changePassword(token: String, newPassword: String)
    case resetPassword(email: String)
}

extension AuthorizationService: TargetType{
    var baseURL: URL {
        return URL(string: "https://sayahatai-backend.onrender.com/auth")!
    }
    
    var path: String {
            switch self{
            case .authorizeUser:
                return "/users/tokens"
            case .registerUser, .deleteUser:
                return "/users"
            case .getMyAccount:
                return "/users/me"
            case .changePassword:
                return "/users/password/change"
            case .resetPassword:
                return "/users/password/reset"
            }
        
    }
    
    var method: Moya.Method {
        switch self{
        case .authorizeUser, .registerUser:
            return .post
        case .getMyAccount:
            return .get
        case .changePassword:
            return .put
        case .deleteUser:
            return .delete
        case .resetPassword:
            return .put
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .authorizeUser:
            return [:]
        case .registerUser:
            return [:]
        case .getMyAccount(let token), .deleteUser(let token):
            return ["accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(token)"]
        case .changePassword(let token, _):
            return ["accept": "application/json",
                    "Authorization": "Bearer \(token)"]
        case .resetPassword(_):
            return ["accept": "application/json"]
        }
    }
    
    var task: Moya.Task {
        switch self{
        case let .authorizeUser(email, password):
            let bodyParams: [String : String] = [
                "email": email,
                "password": password
            ]
            
            return .requestParameters(parameters: bodyParams, encoding: URLEncoding.queryString)
        
        case let .registerUser(email, password):
            let bodyParams: [String : String] = [
                "email": email,
                "password": password
            ]
            
            return .requestJSONEncodable(bodyParams)

        case .getMyAccount, .deleteUser:
            return .requestPlain

        case let .changePassword(_, newPassword):
            let bodyParams: [String : String] = [
                "new_password": newPassword
            ]
            return .requestJSONEncodable(bodyParams)
            
        case let .resetPassword(email):
            let bodyParams: [String : String] = [
                "email": email
            ]
            return .requestJSONEncodable(bodyParams)
        }
    }
    
}
