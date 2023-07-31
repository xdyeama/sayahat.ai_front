//
//  TripView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 18.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TripView: View{
    @ObservedObject var tripsVM: TripsViewModel
    @Binding var isTripDeleted: Bool
    let tripId: String
    let tripTitle: String
    let tripTags: [String]
    let dayPlans: [DayPlanMapModel]
    
    var body: some View{
        ZStack(alignment: .bottomTrailing){
            ZStack{
                Color.white.opacity(0.5)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 12) {
                    tourImageComponent
                    
                    VStack(alignment: .leading, spacing: 8){
                        tripTagsComponent
                            .padding(.top, 16)
                        
                        
                        Text(tripTitle)
                            .font(
                                .headline
                            )
                            .foregroundColor(.black)
                            .frame(width: 341, height: 20, alignment: .leading)
                        
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 10)
                    
                }
            }
            .background(.clear)
            .backgroundStyle(.ultraThinMaterial)
            .frame(maxHeight: 350)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            deleteTripButton
        }
    }
}

extension TripView{
    
    private var tourImageComponent: some View{
        ZStack (alignment: .bottomLeading){
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 200)
                .foregroundColor(.clear)
                .background(
                    WebImage(url: URL(string: getTripImage()))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200))
                .padding(0)
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: 90, maxHeight: 26)
                    .background(Color(red: 1, green: 0.96, blue: 0.62))
                    .cornerRadius(16)
                HStack(spacing: 0){
                    Image(systemName:"mappin")
                        .foregroundColor(.black)
                    Text("\(countPlaces(dayPlans: dayPlans)) places")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black).padding(0)
                }.frame(alignment: .bottomLeading)
            }
            .offset(x: 12, y: 24)
        }
        .frame(height: 200, alignment: .bottomLeading)
        .padding(0)
    }
    
    private var tripTagsComponent: some View{
        HStack(alignment: .center, spacing: 2) {
            ForEach(tripTags, id:\.self){
                tripTag in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 28)
                        .background(Color(red: 0.98, green: 0.66, blue: 0.35))
                        .cornerRadius(16)
                        .frame(maxWidth: 100)
                    Text(tripTag.capitalized.replacingOccurrences(of: "_", with: " "))
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(maxWidth: 80)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private var deleteTripButton: some View{
        Button{
            tripsVM.deleteTrip(tripId: tripId)
            isTripDeleted.toggle()
        }label: {
            ZStack{
                Rectangle()
                    .cornerRadius(5)
                    .foregroundColor(Color.red.opacity(0.6))
                    .backgroundStyle(.clear)
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
            }
            .frame(width: 30, height: 30)
            .padding(.bottom, 7)
            .padding(.trailing, 7)
        }
    }
    
    
    func countPlaces(dayPlans: [DayPlanMapModel]) -> Int{
        var countPlaces: Int = 0
        for dayPlan in dayPlans{
            countPlaces = countPlaces + dayPlan.activities.count
        }
        return countPlaces
    }
    
    func generateTripName() -> String{
        var tripName = "Tour around "
        for dayPlan in dayPlans{
            tripName += "\(dayPlan.city), "
        }
        return tripName
    }
    
    func getTripImage() -> String{
        for dayPlan in dayPlans{
            for activity in dayPlan.activities{
                if let image_url = activity.image_url.first{
                    return image_url
                }
            }
        }
        return ""
    }
}

