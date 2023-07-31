//
//  ChatMessage.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 11.07.2023.
//

import SwiftUI


struct ChatMessage: Identifiable{
    var id = UUID().uuidString
    var owner: MessageOwner
    var text: String
    
    init(
        owner: MessageOwner = .user,
        _ text: String
    ){
        self.owner = owner
        self.text = text
    }
}
