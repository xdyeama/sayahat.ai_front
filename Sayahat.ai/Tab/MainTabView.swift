
//  MainTabView.swift
//  SayahatAI
//
//  Created by Beket Barlykov  on 09.06.2023.
//

import SwiftUI

enum Tab: String, CaseIterable{
    case bag
    case map
    case message
}

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @State var selectedTab: Tab = Tab.bag
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    var body: some View {
        ZStack(alignment: .center){
            Rectangle()
                .frame(width: 350, height: 64)
                .cornerRadius(20)
                .foregroundColor(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 25, x: 0, y: 4)
            TabView(selection: $selectedTab){
                mapTab
                chatTab
                tripsTab
            }
        }

    }
}

extension MainTabView{
    private var background: some View{
        Rectangle()
            .frame(width: 350, height: 64)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .shadow(color: .black.opacity(0.12), radius: 25, x: 0, y: 4)
    }
    
    private var mapTab: some View {
        MapView().tabItem{
            Spacer()
            VStack{
                Image(systemName: selectedTab == .map ? fillImage : Tab.map.rawValue)
                    .scaleEffect(selectedTab == .map ? 1.25 : 1.0)
                    .foregroundColor(selectedTab == .map ? Color.black : Color.gray)
                    .font(.system(size: 22))
                    .onTapGesture{
                        withAnimation(.easeIn(duration: 0.1)){
                            selectedTab = .map
                        }
                    }
                Text("Map")
            }
        }.tag(Tab.map)
    }
    
    private var chatTab: some View{
        ChatView().tabItem{
            Spacer()
            VStack{
                Image(systemName: selectedTab == .message ? fillImage : Tab.message.rawValue)
                    .scaleEffect(selectedTab == .message ? 1.25 : 1.0)
                    .foregroundColor(selectedTab == .message ? Color.black : Color.gray)
                    .font(.system(size: 22))
                    .onTapGesture{
                        withAnimation(.easeIn(duration: 0.1)){
                            selectedTab = .message
                        }
                    }
                Text("Guide")
            }
            Spacer()
        }.tag(Tab.message)
    }
    
    private var tripsTab: some View{
        TripsView(selectedTab: $selectedTab, isLoggedIn: $isLoggedIn)
            .tabItem{
                Spacer()
                VStack{
                    Image(systemName: selectedTab == .bag ? fillImage : Tab.bag.rawValue)
                        .scaleEffect(selectedTab == .bag ? 1.25 : 1.0)
                        .foregroundColor(selectedTab == .bag ? Color.black : Color.gray)
                        .font(.system(size: 22))
                        .onTapGesture{
                            withAnimation(.easeIn(duration: 0.1)){
                                selectedTab = .bag
                            }
                        }
                    Text("Trips")
                }
                Spacer()
            }.tag(Tab.bag)
    }
}
