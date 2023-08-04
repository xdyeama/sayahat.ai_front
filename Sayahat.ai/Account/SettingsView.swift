//
//  SettingsView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 19.07.2023.
//

import SwiftUI
import Moya


struct SettingsView: View {
    @EnvironmentObject var authorizationVM: AuthorizationViewModel
    @State var isDeletionRequest: Bool = false
    @State var isRequestProcessed: Bool = false
    var body: some View {
        VStack{
            List(){
                Section("Privacy and Terms of Use"){
                    Button{
                        openWebsite(url: "https://doc-hosting.flycricket.io/sayahat-ai-terms-of-use/797c43c4-3bd8-4e29-91c7-75abbd88e3d9/terms")
                    }label:{
                        
                        Text("Terms of use")
                            .font(.subheadline)
                    }
                    Button{
                        openWebsite(url: "https://doc-hosting.flycricket.io/sayahat-ai-privacy-policy/52a240d4-f15f-4abb-972d-bde7e7b02973/privacy")
                    }label:{
                        
                        Text("Privacy Policy")
                            .font(.subheadline)
                    }
                    NavigationLink(value: SelectionState.string("FAQ")){
                        Button{
                        }label:{
                            
                            Text("FAQ")
                                .font(.subheadline)
                        }
                    }
                }
                Section("Account"){
                    NavigationLink(value: SelectionState.string("change password")){
                        Button{
                            
                        }label:{
                            Text("Change password")
                        }
                    }
                    Button{
                        AppDataAPI.isLoggedIn = false
                        AppDataAPI.token = ""
                        authorizationVM.isLoggedIn = false
                    }label:{
                        Text("Leave account")
                            .font(.subheadline)
                            .foregroundColor(.yellow)
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
            .navigationTitle("Settings")
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
                                    authorizationVM.isLoggedIn = false
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
    
}

extension SettingsView{
    private func openWebsite(url: String) {
        guard let url = URL(string: url) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Handle the case when the URL cannot be opened (e.g., invalid URL or unsupported scheme)
            showOpenWebsiteAlert()
        }
    }
    
    private func showOpenWebsiteAlert() {
        let alert = UIAlertController(title: "Error", message: "Unable to open the website.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        guard let viewController = window?.rootViewController else {
            return
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}

