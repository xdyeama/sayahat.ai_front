//
//  TripsView.swift
//  SayahatAI
//
//  Created by Beket Barlykov  on 16.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI



struct TripsView: View {
    @StateObject private var tripsVM: TripsViewModel = TripsViewModel()
    @StateObject var inputVM = InputViewModel()
    @Binding var selectedTab: Tab
    @Binding var isLoggedIn: Bool
    @State var tripsNavPath = NavigationPath()
    @State var isTripDeleted: Bool = false

    
    var body: some View {
        NavigationStack(path: $tripsNavPath){
            ZStack(alignment: .top){
                HStack{
                    Spacer()
                    NavigationLink(destination: SettingsView(isLoggedIn: $isLoggedIn)){
                        Image(systemName: "gearshape")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding()
                    }
                    Button{
                        AppDataAPI.isLoggedIn = false
                        AppDataAPI.token = ""
                        isLoggedIn = false
                    }label:{
                        Image(systemName: "door.right.hand.open")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20,height: 20)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }.padding(.trailing, 10)
                ZStack(alignment: .bottomTrailing){
                    VStack(alignment: .center){
                        Text("Your tours")
                            .font(
                                .title
                            )
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(LinearGradient(colors: [.black, .gray], startPoint: .leading, endPoint: .trailing) )
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
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                tripsVM.fetchTrips()
            }
            .navigationDestination(for: TripMapModel.self){ tripModel in
                DaysPlanView(tripTitle: tripModel.trip_title, dayPlans: tripModel.trips)
            }
            .navigationDestination(for: ActivityMapModel.self){
                activityModel in
                
                ActivityDetailsView(title: activityModel.place_name, imageUrl: activityModel.image_url, address: activityModel.address, contactNumber: activityModel.contact_number, rating: activityModel.rating, activityTypes: activityModel.activity_types, website: activityModel.website, description: activityModel.place_description, coordinates: activityModel.coordinates)
            }
        }
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
            ScrollView{
                ForEach(AppDataAPI.trips, id: \.trip_title){
                    trip in
                    NavigationLink(value: trip){
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
            NavigationLink(destination: MainInputView(inputVM: inputVM, navPath: $tripsNavPath, selectedTab: $selectedTab)){
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
        }
    }
    
    private var createTourButtonOverlay: some View{
        Button{
            
        }label: {
            NavigationLink(destination: MainInputView(inputVM: inputVM, navPath: $tripsNavPath, selectedTab: $selectedTab)){
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
