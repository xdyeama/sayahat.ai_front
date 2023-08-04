//
//  IntroMainView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 05.07.2023.
//

import SwiftUI




struct OnboardingView: View {
    @ObservedObject var onboardingVM: OnboardingViewModel
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                TabView{
                    ForEach(introItems, id: \.id){
                        item in
                        OnboardingItemView(title: item.title, subtitle: item.subtitle, image: item.image, isEnd: item.isEnd)
                    }
                }
                .tabViewStyle(.page)
                VStack(alignment: .center, spacing: 12){
                    
                    Button{
                        AppDataAPI.isOnboarding = false
                        onboardingVM.isOnboarding = false
                    }label: {
                        LoginButton()
                    }
                    Button{
                        AppDataAPI.isOnboarding = false
                        onboardingVM.isOnboarding = false
                        
                    }label: {
                        NavigationLink(value: SelectionState.string("Registration")){
                            CustomSignUpButton()
                        }
                    }
                }
                .padding(.horizontal, 80)
            }
        }
        .padding()
    }
}


