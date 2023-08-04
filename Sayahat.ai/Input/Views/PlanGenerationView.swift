//
//  PlanGenerationView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 18.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlanGenerationView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @ObservedObject var inputVM: InputViewModel
    @Binding var selectedTab: Tab
    @State var showAlert: Bool = false
    
    @State var isAnimating: Bool = true
    let textToAnimate = "..."
    @State private var finalText: String = ""
    @State private var animatedText: String = "Planning your trip"
    @State private var currentIndex = 0
    @State private var textIndexToAnimate = 0
    @State private var typingForward = true
    @State private var timer: Timer?
    @State private var shuffledFacts: [CityFact] = []
    @State private var currentFactIndex = 0
    @State private var showFact = false
    
    
    let chosenCities: [String]
    let inputCityFacts: [CityFact] = cityFacts
    
    var filteredFacts: [CityFact] {
        inputCityFacts.filter { chosenCities.contains($0.city) }
    }
    
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 36){
                AnimatedImage(name: "plan_generating.gif", isAnimating:  $isAnimating)
                    .maxBufferSize(.max)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 230, height: 200)
                Text(animatedText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .onAppear{
                        startAnimation()
                    }
                
            }
            VStack{
                Spacer()
                Text("Did you know?")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                if showFact {
                    if let cityFact = shuffledFacts[currentFactIndex]{
                        Text(cityFact.fact)
                            .font(.caption.bold())
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .onAppear{
                                startTimer()
                            }
                            .padding()
                    }
                } else {
                    ProgressView()
                        .onAppear(perform: shuffleFacts)
                }
            }
        }.navigationBarBackButtonHidden(true)
            .alert(Text("The itinerary has been generated"),isPresented: $inputVM.isRequestProcessed){
                Button("Proceed"){
                    navigationStateManager.popToRoot()
                    inputVM.isRequestProcessing = false
                }
            }message:{
                Text("Press the Proceed button to see the newly generated trip")
            }
    }
}

extension PlanGenerationView{
    
    func startAnimation(){
        currentIndex = 14
        animatedText = "Planning your dream journey"
        typingForward = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if inputVM.isTripGenerated{
                showAlert = true
            }
            if typingForward {
                animatedText.append(textToAnimate[textToAnimate.index(textToAnimate.startIndex, offsetBy: currentIndex-14)])
                currentIndex += 1
                
                if currentIndex - 14 == textToAnimate.count {
                    typingForward = false
                    currentIndex -= 1
                }
            } else {
                animatedText.removeLast()
                
                if currentIndex <= 14 {
                    typingForward = true
                } else {
                    currentIndex -= 1
                }
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            if currentFactIndex < shuffledFacts.count - 1 {
                showFact = true
                currentFactIndex += 1
                
            }else{
                currentFactIndex = 0
                showFact = false
            }
        }
    }
    
    func shuffleFacts() {
        shuffledFacts = filteredFacts.shuffled()
        showFact = true
        currentFactIndex = 0
    }
}

