//
//  AuthorizationModel.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 05.07.2023.
//

import SwiftUI
import Moya


struct Token: Codable{
    let access_token: String
    let token_type: String
}

struct RegMap: Codable{
    let email: String
}


class AuthorizationViewModel: ObservableObject{
    let provider = MoyaProvider<AuthorizationService>()
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var token: String = ""
    @Published var regEmail: String = ""
    @Published var regPassword: String = ""
    @Published var restorePassEmail: String = ""
    @Published var loginStatus: LoginStatus = .none
    @Published var registerStatus: RegisterStatus = .none
    
    func register(){
        self.registerStatus = .loading
        provider.request(.registerUser(email: regEmail, password: regPassword)){
            result in
            switch result{
            case .success(let response):
                if response.statusCode == 201{
                    do{
                        self.registerStatus = .success
                        print("User successfuly created")
                        let data = try response.map(RegMap.self)
                        print(data.email)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            self.loginStatus = .none
                        }
                    }catch{
                        self.loginStatus = .failure
                        print("Error decoding JSON: \(error.localizedDescription)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            self.loginStatus = .none
                        }
                    }
                }else{
                    self.loginStatus = .failure
                    print("User registration failed. Response: \(response)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self.loginStatus = .none
                    }
                }
            case .failure(let error):
                self.loginStatus = .failure
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.loginStatus = .none
                }
                
            }
        }
    }
    
    func authorize(){
        self.loginStatus = .loading
        print(email, password)
        provider.request(.authorizeUser(email: email, password: password)){ [weak self]
            result in
            guard let self else { return }
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    do{
                        print("Auntentication successful")
                        self.loginStatus = .success
                        self.token = try response.map(Token.self).access_token
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            self.isLoggedIn = true
                            AppDataAPI.isLoggedIn = true
                            AppDataAPI.token = self.token
                            self.loginStatus = .none
                        }
                        
                    }catch{
                        self.loginStatus = .failure
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            self.loginStatus = .none
                        }
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }else{
                    print("User authorization failed. Response: \(response)")
                    self.loginStatus = .failure
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self.loginStatus = .none
                    }
                    self.isLoggedIn = false
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.loginStatus = .failure
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.loginStatus = .none
                }
                self.isLoggedIn = false
                
            }
        }
    }
    
    func restorePassword(_ responseStatus: Binding<ResponseStatus>){
        provider.request(.resetPassword(email: restorePassEmail)){ result in
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    responseStatus.wrappedValue = ResponseStatus.success
                }else if response.statusCode == 404{
                    responseStatus.wrappedValue = ResponseStatus.userNotExist
                    print("User does not exist")
                }else if response.statusCode == 500{
                    responseStatus.wrappedValue = ResponseStatus.failure
                }
            case .failure(let error):
                print("Error restoring password: \(error.localizedDescription)")
                responseStatus.wrappedValue = ResponseStatus.failure
            }
        }
    }
}

