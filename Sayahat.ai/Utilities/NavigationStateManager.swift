//
//  NavigationManager.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 03.08.2023.
//

import SwiftUI


enum SelectionState: Hashable{
    case string(String)
    case activity(ActivityMapModel)
    case trip(TripMapModel)
    case news(NewsModel)
}

class NavigationStateManager: ObservableObject{
    @Published var path: [SelectionState] = []
    
    func popToRoot(){
        path = []
    }
}
