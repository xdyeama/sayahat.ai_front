//
//  TravelPreferencesView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 04.07.2023.
//

import SwiftUI

enum TravelPreference: String, CaseIterable, Codable{
    case sightseeings
    case sport_complexes
    case museums
    case shopping_centers
    case restaurants
    case theaters
}

func travelPrefsToString(travelPrefs: [TravelPreference]) -> String {
    return travelPrefs.map { $0.rawValue.replacingOccurrences(of: "_", with: " ") }.joined(separator: ", ")
}

func checkSelected(travelPrefs: [TravelPreference], travelCase: TravelPreference) -> Bool{
    return travelPrefs.contains(travelCase) ? true : false
}

struct TravelOption: View{
    @Binding var travelPrefsString: String
    @Binding var travelPrefs: [TravelPreference]
    var travelCase: TravelPreference
    @State var isSelected: Bool = false
    
    var body: some View{
        ZStack{
            if checkSelected(travelPrefs: travelPrefs, travelCase: travelCase){
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 140, height: 140)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 0.5)
                            .stroke(.black.opacity(1), lineWidth: 1)
                    )
            }else{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 140, height: 140)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 4)
            }
            VStack{
                Text(travelCase.rawValue.replacingOccurrences(of: "_", with: " "))
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 140, height: 25, alignment: .top)
                    .padding(.top, 8)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 120, height: 95)
                    .background(
                        Image(travelCase.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    )
                    .cornerRadius(20)
            }
        }.onTapGesture{
            if !travelPrefs.contains(travelCase){
                travelPrefs.append(travelCase)
            }else{
                if let index = travelPrefs.firstIndex(of: travelCase){
                    travelPrefs.remove(at: index)
                }
            }
            travelPrefsString = travelPrefsToString(travelPrefs: travelPrefs)
            isSelected.toggle()
        }
    }
}

struct TravelPreferencesView: View {
    @Binding var travelPrefsString: String
    @Binding var travelPrefs: [TravelPreference]
    var body: some View {
        VStack(){
        
                Rectangle()
                    .frame(width: 100, height: 5)
                    .foregroundColor(.black)
                    .cornerRadius(5)
            VStack{
                Spacer()
                LazyVGrid(columns:[GridItem(.fixed(140)), GridItem(.fixed(140))], alignment: .center, spacing: 8){
                    ForEach(TravelPreference.allCases, id: \.rawValue){
                        pref in
                        TravelOption(travelPrefsString: $travelPrefsString, travelPrefs: $travelPrefs ,travelCase: pref)
                    }
                }
                Spacer()

            }
            Spacer()
                    
            }
        .padding()
        }
    }



