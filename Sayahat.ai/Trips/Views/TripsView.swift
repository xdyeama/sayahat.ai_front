//
//  TripsView.swift
//  SayahatAI
//
//  Created by Beket Barlykov  on 16.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI



struct TripsView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @StateObject private var tripsVM: TripsViewModel = TripsViewModel()
    @StateObject var inputVM = InputViewModel()
    @Binding var selectedTab: Tab
    @Binding var isLoggedIn: Bool
    @State var isTripDeleted: Bool = false
    @State var isRequestProcessing: Bool = false
    @State var isRequestProcessed: Bool = false
    @State var chosenCities: [String] = []
    @State var isActive: Bool = false

    
    var body: some View {
//        NavigationStack(path: $navigationStateManager.path){
            ZStack(alignment: .top){
                HStack{
                    Spacer()
                    NavigationLink(value: SelectionState.string("settings")){
                        Image(systemName: "gearshape")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding()
                    }
                }.padding(.trailing, 10)
                    .padding(.top, 18)
                ZStack(alignment: .bottomTrailing){
                    VStack(alignment: .center){
                        Text("Your tours")
                            .font(
                                .title
                            )
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.black)
                            .padding(.top, 26)
                        VStack(alignment: .center){
                            if AppDataAPI.trips.isEmpty{
                                noToursView
                            }else{
                                tripList
                            }
                        }
                    }
                    if !AppDataAPI.trips.isEmpty{
                        createTourButtonOverlay
                            .padding(.bottom, 16)
                    }
                }
            }
            .onAppear{
                tripsVM.fetchTrips()
            }
//        }
    }
}



extension TripsView{
    private var noToursView: some View{
        VStack(alignment: .center){
            Image("tourists")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 200)
            Text("You have no tours planned")
                .font(
                    .title
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            createTourButton
                .disabled(AppDataAPI.token == "" ? true : false)
        }.frame(width: 350, height: 600)
            .padding()
    }
    
    private var tripList: some View{
        ZStack{
            ScrollView(showsIndicators: false){
                ForEach(AppDataAPI.trips.reversed(), id: \.trip_title){
                    trip in
                    NavigationLink(value: SelectionState.trip(trip)){
                        TripView(tripsVM: tripsVM, isTripDeleted: $isTripDeleted, tripId: trip._id, tripTitle: trip.trip_title, tripTags: trip.trip_tags,  dayPlans: trip.trips)
                    }
                }
            }
            .clipped()
            .ignoresSafeArea(.all)
        }.frame(height: 600)
            .ignoresSafeArea(.all)
            .padding()
    }
    
    
    private var createTourButton: some View{
        Button{
            
        }label: {
            NavigationLink(value: SelectionState.string("input")){
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 157.12762, height: 38)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(6)
                    Text("Create new tour")
                        .font(
                            .headline
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 149.20497, height: 24, alignment: .top)
                }
                .frame(width: 157.12762, height: 38)
                .padding(30)
            }
            .isDetailLink(false)

        }
    }
    
    private var createTourButtonOverlay: some View{
        Button{
            
        }label: {
            NavigationLink(value: SelectionState.string("input")){
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 50, height: 50)
                        .background()
                        .cornerRadius(50)
                        .overlay{
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        }
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }
            }
            .isDetailLink(false)
        }
        .padding(.trailing, 30)
        .padding(.bottom, 30)
    }
}


//struct TripsView_Preview: PreviewProvider{
//    static var previews: some View{
//        TripsView()
//    }
//}
