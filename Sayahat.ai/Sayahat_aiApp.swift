//
//  Sayahat_aiApp.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 25.07.2023.
//

import SwiftUI


@main
struct Sayahat_aiApp: App {
    @State var isLoggedIn: Bool = false
    @State var selectedTab: Tab = Tab.bag
    @StateObject var navigationStateManager = NavigationStateManager()
    @StateObject var onboardingVM = OnboardingViewModel()
    @StateObject var authorizationVM: AuthorizationViewModel = AuthorizationViewModel()
    @StateObject var inputVM: InputViewModel = InputViewModel()
    @StateObject var networkMonitor: NetworkMonitor = NetworkMonitor()
    let appearance: UITabBarAppearance = UITabBarAppearance()

    init(){
        UITabBar.appearance().scrollEdgeAppearance = appearance

    }
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationStateManager.path){
                Group{
                    if AppDataAPI.isOnboarding {
                        onboarding
                    }else{
                        if !AppDataAPI.isLoggedIn && !authorizationVM.isLoggedIn{
                            authorization
                        } else {
                            mainTab
                        }
                    }
                }
            }.environmentObject(navigationStateManager)
                .environmentObject(onboardingVM)
                .environmentObject(authorizationVM)
                .environmentObject(inputVM)
                .environmentObject(networkMonitor)
                .onAppear{
                    print("Is onboarding: \(AppDataAPI.isOnboarding)")
                    print("Is loggedin: \(AppDataAPI.isLoggedIn)")
                    print("Token: \(AppDataAPI.token)")
                    
                }
        }
    }
}

extension Sayahat_aiApp{
    private var onboarding: some View{
        OnboardingView(onboardingVM: onboardingVM)
            .preferredColorScheme(.light) // Force light mode
            .navigationDestination(for: SelectionState.self){ state in
                switch state{
                case .string(let value):
                    switch value{
                        case "forgot password":
                            ForgotPasswordView()
                        case "Authorization":
                            AuthorizationView()
                        case "Registration":
                            RegistrationView()
                        case "settings":
                            SettingsView()
                        case "input":
                        MainInputView(selectedTab: $selectedTab)
                    case "change password":
                        ChangePasswordView(authorizationVM: AuthorizationViewModel())
                    case "FAQ":
                        FAQView()
                    default:
                        EmptyView()
                    }
                case .trip(let tripModel):
                    DaysPlanView(tripTitle: tripModel.trip_title, dayPlans: tripModel.trips)
                case .activity(let activityModel):
                    ActivityDetailsView(title: activityModel.place_name, imageUrl: activityModel.image_url, address: activityModel.address, contactNumber: activityModel.contact_number, rating: activityModel.rating, activityTypes: activityModel.activity_types, website: activityModel.website, description: activityModel.place_description, coordinates: activityModel.coordinates)
                case .news(let newsItem):
                    NewsDetailView(title: newsItem.title, image_url: newsItem.image_url, author: newsItem.author, published_date: newsItem.published_date, url: newsItem.url, text_list: newsItem.text_list)
                }
            }
    }
    
    private var authorization: some View{
        AuthorizationView()
            .preferredColorScheme(.light)
            .navigationDestination(for: SelectionState.self){ state in
                switch state{
                case .string(let value):
                    switch value{
                        case "forgot password":
                            ForgotPasswordView()
                        case "Authorization":
                            AuthorizationView()
                        case "Registration":
                            RegistrationView()
                        case "settings":
                            SettingsView()
                        case "input":
                        MainInputView(inputVM: inputVM, selectedTab: $selectedTab)
                    case "change password":
                        ChangePasswordView(authorizationVM: AuthorizationViewModel())
                    case "FAQ":
                        FAQView()
                    default:
                        EmptyView()
                    }
                case .trip(let tripModel):
                    DaysPlanView(tripTitle: tripModel.trip_title, dayPlans: tripModel.trips)
                case .activity(let activityModel):
                    ActivityDetailsView(title: activityModel.place_name, imageUrl: activityModel.image_url, address: activityModel.address, contactNumber: activityModel.contact_number, rating: activityModel.rating, activityTypes: activityModel.activity_types, website: activityModel.website, description: activityModel.place_description, coordinates: activityModel.coordinates)
                case .news(let newsItem):
                    NewsDetailView(title: newsItem.title, image_url: newsItem.image_url, author: newsItem.author, published_date: newsItem.published_date, url: newsItem.url, text_list: newsItem.text_list)
                }
            }
    }
    
    private var mainTab: some View{
        MainTabView(isLoggedIn: $isLoggedIn)
            .preferredColorScheme(.light)
            .navigationDestination(for: SelectionState.self){ state in
                switch state{
                case .string(let value):
                    switch value{
                        case "forgot password":
                            ForgotPasswordView()
                        case "Authorization":
                            AuthorizationView()
                        case "Registration":
                            RegistrationView()
                        case "settings":
                            SettingsView()
                        case "input":
                        MainInputView(inputVM: inputVM, selectedTab: $selectedTab)
                    case "change password":
                        ChangePasswordView(authorizationVM: AuthorizationViewModel())
                    case "FAQ":
                        FAQView()
                    default:
                        EmptyView()
                    }
                case .trip(let tripModel):
                    DaysPlanView(tripTitle: tripModel.trip_title, dayPlans: tripModel.trips)
                case .activity(let activityModel):
                    ActivityDetailsView(title: activityModel.place_name, imageUrl: activityModel.image_url, address: activityModel.address, contactNumber: activityModel.contact_number, rating: activityModel.rating, activityTypes: activityModel.activity_types, website: activityModel.website, description: activityModel.place_description, coordinates: activityModel.coordinates)
                case .news(let newsItem):
                    NewsDetailView(title: newsItem.title, image_url: newsItem.image_url, author: newsItem.author, published_date: newsItem.published_date, url: newsItem.url, text_list: newsItem.text_list)
                }
            }
    }
}
