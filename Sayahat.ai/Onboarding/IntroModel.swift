//
//  IntroItem.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 05.07.2023.
//

import SwiftUI





struct IntroItem: Identifiable{
    let id = UUID()
    var title: String
    var subtitle: String
    var image: String
    var isEnd: Bool
}

let introItems: [IntroItem] = [
    IntroItem(title: "Chat with personal AI tour guide", subtitle: "Ask it any information", image: "intro-1", isEnd: false),
    IntroItem(title: "Explore Kazakhstan", subtitle: "Like never before", image: "intro-2", isEnd: false),
    IntroItem(title: "Create your dream journey", subtitle: "using the latest AI technologies", image: "intro-3", isEnd: true),
]


class OnboardingViewModel: ObservableObject{
    @Published var isOnboarding: Bool = true
    @Published var token: String = ""
}
