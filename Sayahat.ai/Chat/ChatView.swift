//
//  ChatView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 02.07.2023.
//

import SwiftUI
import Combine

struct ChatView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @StateObject var chatVM: ChatViewModel = ChatViewModel()

    
    
    var body: some View {
            VStack{
                header
                ScrollViewReader{ proxy in
                    ScrollView{
                        LazyVStack(spacing: 16){
                            ForEach(chatVM.chatMessages){ message in
                                messageView(message)
                            }
                            
                            Color.clear.frame(height: 1).id("bottom")
                        }
                    }
                    .onReceive(chatVM.$chatMessages.throttle(for: 0.5, scheduler: RunLoop.main, latest: true)){ chatMessages in
                        guard !chatMessages.isEmpty else { return }
                        withAnimation{
                            proxy.scrollTo("bottom")
                        }
                    }
                }
                if networkMonitor.isConnected{
                    HStack{
                        
                        TextField("Message", text: $chatVM.message, axis: .vertical)
                            .foregroundColor(.black)
                            .autocorrectionDisabled(true)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color("TextField"))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .textInputAutocapitalization(.never)
                        
                        if chatVM.isWaitingResponse{
                            ProgressView()
                                .padding()
                        }else{
                            Button{
                                chatVM.sendMessage()
                            }label: {
                                Image(systemName: "paperplane.fill")
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                    .scaledToFit()
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 50)
                }else{
                    Text("No internet connection. Please connect to the internet and try again")
                        .font(.callout.bold())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                }
            }
        .padding(.horizontal)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension ChatView{
    private var header: some View{
        HStack{
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 70, height: 70)
                .foregroundColor(.clear)
                .background(
                    Image("chat_avatar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                )
                .overlay{
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(.white)
                }
            VStack(alignment: .leading){
                Text("Guide")
                    .font(.title3.bold())
                    .foregroundColor(.black)
                if chatVM.isWaitingResponse{
                    Text("Typing...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }else{
                    Text("online")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 100, alignment: .center)
    }
    
    func messageView(_ message: ChatMessage) -> some View{
        HStack{
            if message.owner == .user{
                Spacer(minLength: 60)
            }
            if !message.text.isEmpty{
                VStack{
                    Text(message.text)
                        .foregroundColor(message.owner == .user ? .white : Color("Text"))
                        .padding(12)
                        .background(message.owner == .user ? Color("UserChatMessageBg") : Color(red: 133 / 255,green: 252,blue: 131 / 255))
                        .cornerRadius(16)
                        .overlay(alignment: message.owner == .user ? .topTrailing : .topLeading){
                            Text(message.owner.rawValue.capitalized)
                                .foregroundColor(Color("Text"))
                                .font(.caption)
                                .offset(y: -16)
                        }
                }
            }
            if message.owner == .guide{
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal)
    }
    
    private func hideKeyboard() {
            // End editing by resigning the first responder status
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatVM: ChatViewModel())
    }
}
