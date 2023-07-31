//
//  CitiesInputView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 03.07.2023.
//

import SwiftUI

enum CityCases: String, CaseIterable, Codable{
    case almaty
    case astana
    case shymkent
    case aktobe
    case turkistan
    case aqtau
    case atyrau
    case semey
    case oskemen
    case karaganda
    case taldykorgan
    case pavlodar
    case taraz
    case uralsk
    case kyzylorda
    case kokshetau
    case kostanay
}

func checkCitiesSelected(citiesList: [CityCases], city: CityCases) -> Bool{
    return citiesList.contains(city) ? true : false
}


struct MainInputView: View {
    @ObservedObject var inputVM: InputViewModel
    @Binding var navPath: NavigationPath
    @Binding var selectedTab: Tab
    // cities input
    
    // num days input
    @State private var selectedDays: Int = 1 // Default value
    // travel preferences input
    @State var isRequestProcessing = false
    @State var isRequestProcessed: Bool = false
    
    @State var citiesString: String = ""
    @State var travelPrefsString: String = ""
    
    // other ui states
    let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State var isExpanded: Bool = false
    @State var isCitiesFormExpanded: Bool = false
    @State var viewOffset: CGFloat = 0
    @State var tripTitle: String = ""
    @State var cities: [CityCases] = []
    @State var travelPrefs: [TravelPreference] = []
    
    private var chosenCities: [String] {
            cities.map { $0.rawValue.capitalized }
        }
    
    
    var body: some View {
        
        ZStack{
            if isRequestProcessing{
                PlanGenerationView(inputVM: inputVM, isRequestProcessed: $isRequestProcessed, selectedTab: $selectedTab, path: $navPath, chosenCities: chosenCities)
            }else{
                VStack{
                    Form{
                    
                            citiesInputContainer
                                                    
                            numDaysInputContainer

                            travelPrefsInputContainer

                            
                            tripTitleInputContainer
                            

                        
                    }.sheet(isPresented: $isExpanded){
                        CitiesInputForm(cities: $cities, citiesString: $citiesString, isExpanded: $isExpanded, viewOffset: $viewOffset)
                    }
                    .sheet(isPresented: $isCitiesFormExpanded){
                        TravelPreferencesView(travelPrefsString: $travelPrefsString, travelPrefs: $travelPrefs)
                    }
                    generateTripButton
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                // Dismiss the keyboard when tapping the background
                self.endEditing()
            }
    }
}


extension MainInputView{
    private var buttonsList: some View{
        VStack{
            if cities != []{
                Text(citiesString)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }else{
                Text("Tap here to add cities")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color(.gray))
        }
        .onTapGesture{
            isExpanded.toggle()
        }
    }
    
    private var subtitle: some View{
        Text("Choose cities you are willing to visit")
            .font(.subheadline)
            .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
            .frame(width: 262, height: 27, alignment: .topLeading)
            .multilineTextAlignment(.center)
    }
    
    private var title: some View {
        Text("What cities do you plan to visit?")
            .font(
                .callout.bold()
            )
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
            .frame(height: 24, alignment: .topLeading)
            .multilineTextAlignment(.center)
    }
    
    private var tripTitleInputContainer: some View{
        Section(header: Text("Name your trip")){
            VStack(alignment: .center){
                Text("Give a name for your upcoming trip")
                    .font(.headline)
                    .fontWeight(.semibold)
                TextField("Enter the trip title", text: $tripTitle)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .foregroundColor(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
            }
        }
    }
    
    private var citiesInputContainer: some View{
        Section(header: Text("Cities you wish to visit")){
            VStack(alignment: .center){
//                title
                subtitle
                buttonsList
            }.backgroundStyle(.ultraThickMaterial)
        }
    }
    private var numDaysInputContainer: some View{
        Section(header: Text("Number of Days")) {
                        Picker("Days", selection: $selectedDays) {
                            ForEach(1...5, id: \.self) { day in
                                Text("\(day) day\(day == 1 ? "" : "s")")
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle to show as dropdown
            Text("Note that the more days you choose, the longer the trip generation will take time. For the fastest trip generation choose 1-2 days.")
                .font(.caption)
                .foregroundColor(.gray)
                    }
    }
    
    private var travelPrefsInputContainer: some View{
        Section(header: Text("Travel wishes")){
            VStack{
                Text("What aspects of the travel do you want to focus on?")
                    .font(
                        .callout.bold()
                    )
                    .foregroundColor(Color(red: 0.09, green: 0.11, blue: 0.18))
                    .frame(width: 340, height: 50, alignment: .center)
                VStack{
                    if travelPrefs == []{
                        Text("Tap here to add travel preferences")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }else{
                        Text(travelPrefsString)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    Rectangle()
                        .frame(width: 300, height: 2)
                        .foregroundColor(Color(.gray))
                }
                .onTapGesture{
                    isCitiesFormExpanded.toggle()
                }
            }
            .backgroundStyle(.ultraThinMaterial)
            .padding(.vertical, 10)
        }
    }
    
    private var generateTripButton: some View{
        Button{
            navPath = NavigationPath()
            inputVM.citiesString = citiesString
            inputVM.travelPreferences = travelPrefs
            inputVM.tripTitle = tripTitle
            inputVM.numDays = selectedDays
            inputVM.generateTrip($isRequestProcessed, $isRequestProcessing, $selectedTab)
        }label: {
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 154, height: 50)
                    .cornerRadius(10)
                Text("Generate your trip")
                    .font(
                        .callout.bold()
                    )
                    .foregroundColor(.black)
            }
        }
    }
}


