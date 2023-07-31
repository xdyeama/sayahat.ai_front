//
//  LocationsListView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 16.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct LocationsListView: View {
    @ObservedObject var locationsVM: LocationsViewModel
    var body: some View {
        List{
            ForEach(locationsVM.trips){trip in
                Button{
                    //locationsVM.showNextTrip(nextTrip: trip)
                    withAnimation(.easeInOut){
                        locationsVM.currTrip = trip
                        locationsVM.locations = trip.locations
                        if let nextLocation = trip.locations.first{
                            //locationsVM.showNextLocation(nextLocation: nextLocation)
                            withAnimation(.easeInOut) {
                                locationsVM.currMapLocation = nextLocation
                                locationsVM.showLocationsList = false
                            }
                        }
                        locationsVM.showLocationsList = false
                        
                    }
                }label:{
                    tripsListItem(trip: trip)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

extension LocationsListView{
    
    private func tripsListItem(trip: TripMap) -> some View{
        HStack{
            if let imageName = trip.locations.first?.imageNames.first {
                WebImage(url: URL(string: imageName))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .cornerRadius(10)
            }
            Text(trip.trip_title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//struct LocationsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationsListView()
//            .environmentObject(LocationsViewModel())
//    }
//}
