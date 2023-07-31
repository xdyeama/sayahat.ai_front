//
//  Sayahat_aiApp.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 25.07.2023.
//

import SwiftUI

@main
struct Sayahat_aiApp: App {
    @State var navPath = NavigationPath()
    @State var isLoggedIn: Bool = false
    @StateObject var onboardingVM = OnboardingViewModel()
    @StateObject var authorizationVM: AuthorizationViewModel = AuthorizationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                if AppDataAPI.isOnboarding {
                    OnboardingView(onboardingVM: onboardingVM)
                        .preferredColorScheme(.light) // Force light mode
                        .navigationDestination(for: String.self){
                            value in
                            value == "forgot password" ? ForgotPasswordView(authorizationVM: authorizationVM) : nil
                            value == "Authorization" ? AuthorizationView(authorizationVM: authorizationVM, isLoggedIn: $isLoggedIn) : nil
                            value == "Registration" ? RegistrationView(authorizationVM: authorizationVM, isLoggedIn: $isLoggedIn) : nil
                        }

                }else{
                    if !AppDataAPI.isLoggedIn && !isLoggedIn{
                        AuthorizationView(authorizationVM: authorizationVM, isLoggedIn: $isLoggedIn)
                            .preferredColorScheme(.light)
                            .navigationDestination(for: String.self){
                                value in
                                value == "forgot password" ? ForgotPasswordView(authorizationVM: authorizationVM) : nil
                                value == "Authorization" ? AuthorizationView(authorizationVM: authorizationVM, isLoggedIn: $isLoggedIn) : nil
                                value == "Registration" ? RegistrationView(authorizationVM: authorizationVM, isLoggedIn: $isLoggedIn) : nil
                            }

                    } else {
                        MainTabView(isLoggedIn: $isLoggedIn)
                            .preferredColorScheme(.light) // Force light mode
                    }
                }
            }
            .onAppear{
                print("Is onboarding: \(AppDataAPI.isOnboarding)")
                print("Is loggedin: \(AppDataAPI.isLoggedIn)")
                print("Token: \(AppDataAPI.token)")

            }
        }
    }
}
