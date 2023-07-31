//
//  SettingsView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 19.07.2023.
//

import SwiftUI
import Moya


struct SettingsView: View {
    @State var isDeletionRequest: Bool = false
    @State var isRequestProcessed: Bool = false
    @Binding var isLoggedIn: Bool
    var body: some View {
        VStack{
            Text("Settings")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            List(){
                Section("Account"){
                    NavigationLink(destination: FAQView()){
                        
                        Button{
                        }label:{
            
                            Text("FAQ")
                                .font(.subheadline)
                        }
                    }
                    NavigationLink(destination: ChangePasswordView(authorizationVM: AuthorizationViewModel())){
                        Button{
                            
                        }label:{
                            Text("Change password")
                        }
                    }
                    Button{
                        isDeletionRequest.toggle()
                    }label:{
                        Text("Request account deletion")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
        }

        .alert(Text("Confirm account deletion"),isPresented: $isDeletionRequest){
            Button("Delete"){
                let provider = MoyaProvider<AuthorizationService>()
                
                provider.request(.deleteUser(token: AppDataAPI.token)){
                    result in
                    switch result{
                    case .success(let response):
                        if response.statusCode == 200{
                            do{
                                AppDataAPI.isLoggedIn = false
                                AppDataAPI.token = ""
                                isLoggedIn = false
                            }catch{
                                print("Error decoding JSON: \(error.localizedDescription)")
                            }
                        }else{
                            print("User deletion failed. Response: \(response)")
                        }
                    case .failure(let error):
                        print("Error while deleting account: \(error.localizedDescription)")

                    }
                }
            }
        }message:{
            Text("Note that toy will not be able to restore account after deletion and all data will be erased.")
        }
    }
}

