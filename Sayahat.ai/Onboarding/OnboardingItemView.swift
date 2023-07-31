//
//  IntroItemView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 05.07.2023.
//

import SwiftUI


struct OnboardingItemView: View {
    var title: String
    var subtitle: String
    var image: String
    var isEnd: Bool
    
    var body: some View {
        VStack(spacing: 10){
            VStack(spacing: 10){
                Text(title)
                    .font(.title)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.09, green: 0.11, blue: 0.18))
                Text(subtitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
            }
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 375, height: 323)
                .background(
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                )
        }
    }
}

struct IntroItemView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingItemView(title: "Chat with personal AI tour guide", subtitle: "Ask it any information", image: "intro-1", isEnd: false)
    }
}

