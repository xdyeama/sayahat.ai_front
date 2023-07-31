//
//  ChatViewModel.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 22.07.2023.
//

import SwiftUI
import Combine


class ChatViewModel: ObservableObject{
    let openAIService = OpenAIService()
    @Published var message = ""
    @Published var chatMessages: [ChatMessage] = [ChatMessage(owner: MessageOwner.guide, "Hi, I am your personal tour guide about Kazakhstan. You can ask any information regarding kazakh people, their history, culture, customs and many more.")]
    @Published var isWaitingResponse = false
    @Published var cancellables = Set<AnyCancellable>()

    
    
    func sendMessage(){
        isWaitingResponse = true
        let userMessage = ChatMessage(message)
        chatMessages.append(userMessage)
        openAIService.sendMessage(message: message).sink{ completion in
        }receiveValue: { [self]response in
            guard let textResponse = response.choices.first?.message["content"] else { return }
            let gptMessage = ChatMessage(owner:.guide, textResponse)
            chatMessages.append(gptMessage)
        }.store(in: &cancellables)
        
        message = ""
        isWaitingResponse = false
    }
}
