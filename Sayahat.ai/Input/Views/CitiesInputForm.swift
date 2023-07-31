//
//  CitiesInputForm.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 22.07.2023.
//

import SwiftUI

func citiesToString(cities: [CityCases]) -> String {
    return cities.map { $0.rawValue.capitalized }.joined(separator: ", ")
}


struct CityOption: View{
    @Binding var cities: [CityCases]
    @Binding var citiesString: String
    var city: CityCases
    @State var isSelected: Bool
    
    var body: some View{
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 144.60976, height: 154)
                .background(
                    Image(city.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 154, height: 154)
                        .clipped()
                )
                .cornerRadius(15)
                .overlay(isSelected == true ?
                         RoundedRectangle(cornerRadius: 15)
                    .inset(by: 1)
                    .stroke(Color(red: 0, green: 1, blue: 0.1), lineWidth: 2) : nil
                )
            
            Text(city.rawValue.capitalized)
                .font(.subheadline.bold())
                .foregroundColor(.yellow)
                .frame(alignment: .center)
        }
        .frame(width: 154, height: 154)
        .onTapGesture{
            if !cities.contains(city){
                cities.append(city)
            }else{
                if let index = cities.firstIndex(of: city){
                    cities.remove(at: index)
                }
            }
            citiesString = citiesToString(cities: cities)
            print(cities)
            print(citiesString)
            isSelected.toggle()
        }
    }
}


struct CitiesInputForm: View {
    @Binding var cities: [CityCases]
    @Binding var citiesString: String
    let gridColumns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    @Binding var isExpanded: Bool
    @Binding var viewOffset: CGFloat
    var body: some View{
        ZStack{
            Color(red: 0.2, green: 0.29, blue: 0.35)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 100, height: 5)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                
                optionsList
            }
            .ignoresSafeArea(.all)
        }
    }
}

extension CitiesInputForm{
    private var optionsList: some View{
        ScrollView{
            LazyVGrid(columns: gridColumns, spacing: 16){
                ForEach(CityCases.allCases, id: \.rawValue){
                    city in
                    CityOption(cities: $cities, citiesString: $citiesString, city: city, isSelected: cities.contains(city) )
                }
            }
        }
        .padding(0)
        .frame(alignment: .top)
    }
}
