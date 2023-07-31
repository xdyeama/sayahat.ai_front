//
//  DaysPlanView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 02.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI


struct Loc{
    let lat: Float
    let lng: Float
}


struct dayButton: View{
    @Binding var activeDay: Int
    var title: String
    var value: Int
    var body: some View{
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 73, height: 23)
                .background(Color(red: 0.22, green: 0.7, blue: 1))
                .opacity(activeDay == value ? 1 : 0.1)
                .cornerRadius(10)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 42.94118, height: 23, alignment: .center)
        }
        .frame(maxWidth: 80, maxHeight: 30)
        .onTapGesture {
            activeDay = value
        }
    }
}

struct ActivityView: View{
    let activityName: String
    let activityImageUrl: [String]
    let activityTypes: [String]
    let rating: Float
    let coordinates: [String:Float]
    let city: String
    let website: String
    var body: some View{
        VStack(spacing: 10){
            imageContainer
            infoContainer
        }.padding()
    }
}

extension ActivityView{
    private var imageContainer: some View{
        VStack{
            ZStack(alignment: .topTrailing){
                if let imageUrl = activityImageUrl.randomElement(){
                    WebImage(url: URL(string: imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .cornerRadius(10)
                }
                
                HStack{
                    Spacer()
                    Button{
                        openWebsite()
                    }label: {
                        
                        Text("Book Now")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .background{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 70, height: 30)
                                    .foregroundColor(
                                        Color.yellow.opacity(1)
                                    )
                            }
                    }
                }.padding(.top, 15)
                    .padding(.trailing, 15)
                
            }
        }
    }
    
    private var infoContainer: some View{
        VStack(alignment: .leading, spacing: 5){
            Text(activityName)
                .font(.caption.bold())
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .frame(width: .infinity)
            HStack(spacing: 1){
                Text(city)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .foregroundColor(.yellow)
                    Text(String(rating))
                        .font(.caption.bold())
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                }
            }
        }
        .frame(maxWidth: 400)
    }
    
    private var ratingView: some View{
        HStack{
            Image(systemName: "star.fill")
                .foregroundColor(Color.yellow)
            Text(String(rating))
                .font(.caption2)
        }
    }
    
    private func openWebsite() {
            guard let url = URL(string: website) else { return }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Handle the case when the URL cannot be opened (e.g., invalid URL or unsupported scheme)
                showOpenWebsiteAlert()
            }
        }

        private func showOpenWebsiteAlert() {
            let alert = UIAlertController(title: "Error", message: "Unable to open the website.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first

            guard let viewController = window?.rootViewController else {
                return
            }
            viewController.present(alert, animated: true, completion: nil)
        }
}

struct DaysPlanView: View {
    var tripTitle: String
    @State var activeDay: Int = 0
    var dayPlans: [DayPlanMapModel]
    let colors: [Color] = [Color.blue, Color.green, Color.purple, Color.cyan, Color.brown, Color.orange, Color.teal]
    
    
    var body: some View {
        VStack {
            tripTitleView
            horizDaysView
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 343, height: 1)
                .background(Color(red: 0.23, green: 0.23, blue: 0.23))
                .padding(0)
            
            dayPlansView
                .padding(0)
                .frame(alignment: .topLeading)
            Spacer()
        }
    }
}

extension DaysPlanView{
    private var tripTitleView: some View{
        Text(tripTitle)
            .font(
                .title3
            )
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 0, green: 0.09, blue: 0.2))
    }
    
    private func sideElement(color: Color) -> some View{
        VStack(alignment: .center, spacing: 3){
            Image(systemName: "drop")
                .resizable()
                .rotationEffect(Angle(degrees: 180))
                .frame(width: 15, height: 15)
                .foregroundColor(color)
            ForEach(0..<19) { index in
                Rectangle()
                    .frame(width: 2, height: 5)
                    .foregroundColor(color)
                    .padding(0)
            }
            Image(systemName: "location")
                .rotationEffect(Angle(degrees: 135))
                .foregroundColor(color)
                .padding(.top, 0)
                .padding(.bottom, 5)
            
            
        }.frame(width: 5)
            .padding(.leading, 10)
            .ignoresSafeArea()
    }
    
    private func distanceElem(activity: ActivityMapModel, nextActivity: ActivityMapModel) -> some View{
        HStack{
            if let distance = distanceBetween(activity, nextActivity){
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("\(Int(distance*10)) km")
                    .font(.caption)
                Image(systemName: "car.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("\(Int(distance*10/60*60)) mins")
                    .font(.caption)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 20)
        .padding(.leading, 20)
    }
    
    private var dayPlansView: some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(dayPlans, id: \.id){
                    dayPlan in
                    Text("Day \(dayPlan.day_num) - \(dayPlan.city)")
                        .font(
                            .headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0, green: 0.09, blue: 0.2))
                        .frame(width: 350, height: 21, alignment: .top)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(dayPlan.activities, id:\.id){
                            activity in
                            HStack(spacing: 1){
                                sideElement(color: colors[dayPlan.day_num - 1])
                                VStack(spacing: 0){
                                    NavigationLink(value: activity){
                                        ActivityView(activityName: activity.place_name, activityImageUrl: activity.image_url, activityTypes: activity.activity_types, rating: activity.rating, coordinates: activity.coordinates, city: dayPlan.city, website: activity.website)
                                    }
                                    if let nextActivity = dayPlan.activities[(dayPlan.activities.firstIndex(of: activity) ?? 0)+1]{
                                        distanceElem(activity: activity, nextActivity: nextActivity)
                                    }
                                }
                                }
                            }
                        
                    }
                    .frame(width: 358, height: nil, alignment: .topLeading)
                        .padding(.top, -20)
                }
            }
        }
    }
    
    private var horizDaysView: some View{
        HStack(spacing: 6) {
            ForEach(0...dayPlans.count, id: \.self){ dayNum in
                dayButton(activeDay: $activeDay, title: dayNum == 0 ? "All" : "Day \(dayNum)", value: dayNum)
            }
        }
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    func distanceBetween(_ activity: ActivityMapModel, _ nextActivity: ActivityMapModel) -> Float {
        let location1 = Loc(lat: activity.coordinates["lat"]!, lng: activity.coordinates["lng"]!)
        let location2 = Loc(lat: nextActivity.coordinates["lat"]!, lng: nextActivity.coordinates["lng"]!)
        let earthRadiusKm: Double = 6371.0 // Earth's radius in kilometers
        let dLat = degreesToRadians(Double(location2.lat - location1.lat))
        let dLon = degreesToRadians(Double(location2.lng - location1.lng))
        let lat1 = degreesToRadians(Double(location1.lat))
        let lat2 = degreesToRadians(Double((location2.lat)))
        
        let a = (sin(dLat / 2) * sin(dLat / 2) + sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2))
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        let distance = earthRadiusKm * c
        return Float(distance)
    }
}

//
struct DaysPlanView_Preview: PreviewProvider{
    static var previews: some View{
        DaysPlanView(tripTitle: "Tour around Almaty", dayPlans: [DayPlanMapModel(day_num: 1, city: "Almaty", activities: [ActivityMapModel( place_name: "Central State Museum of the Republic of Kazakhstan", address: "Samal-1, 44, Almaty 050059, Kazakhstan", place_description: "The Central State Museum of the Republic of Kazakhstan is the largest museum in Kazakhstan, showcasing the country\'s rich history and cultural heritage. It houses a vast collection of artifacts, including archaeological finds, traditional crafts, and works of art.", coordinates:
                                                                                                                                            ["lat": 43.242387,
                                                                                                                                             "lng": 76.93013], website: "http://csmrk.kz/", contact_number: "8 (7272) 64 26 80", rating: 4.3, rating_count: 2487, activity_types: [
                                                                                                                                                "museum",
                                                                                                                                                "tourist_attraction",
                                                                                                                                                "point_of_interest",
                                                                                                                                                "establishment"
                                                                                                                                             ], photo_ref: "", image_url: [
                                                                                                                                                "https://s3-eu-north-1.amazonaws.com/sayahatai/places/Almaty/central_state_museum_of_the_republic_of_kazakhstan.png"
                                                                                                                                             ]), ActivityMapModel( place_name: "Central State Museum of the Republic of Kazakhstan", address: "Samal-1, 44, Almaty 050059, Kazakhstan", place_description: "The Central State Museum of the Republic of Kazakhstan is the largest museum in Kazakhstan, showcasing the country\'s rich history and cultural heritage. It houses a vast collection of artifacts, including archaeological finds, traditional crafts, and works of art.", coordinates:
                                                                                                                                                                    ["lat": 43.242387,
                                                                                                                                                                     "lng": 76.93013], website: "http://csmrk.kz/", contact_number: "8 (7272) 64 26 80", rating: 4.3, rating_count: 2487, activity_types: [
                                                                                                                                                                        "museum",
                                                                                                                                                                        "tourist_attraction",
                                                                                                                                                                        "point_of_interest",
                                                                                                                                                                        "establishment"
                                                                                                                                                                     ], photo_ref: "", image_url: [
                                                                                                                                                                        "https://s3-eu-north-1.amazonaws.com/sayahatai/places/Almaty/central_state_museum_of_the_republic_of_kazakhstan.png"
                                                                                                                                                                     ]), ActivityMapModel(place_name: "Central State Museum of the Republic of Kazakhstan", address: "Samal-1, 44, Almaty 050059, Kazakhstan", place_description: "The Central State Museum of the Republic of Kazakhstan is the largest museum in Kazakhstan, showcasing the country\'s rich history and cultural heritage. It houses a vast collection of artifacts, including archaeological finds, traditional crafts, and works of art.", coordinates:
                                                                                                                                                                                            ["lat": 43.242387,
                                                                                                                                                                                             "lng": 76.93013], website: "http://csmrk.kz/", contact_number: "8 (7272) 64 26 80", rating: 4.3, rating_count: 2487, activity_types: [
                                                                                                                                                                                                "museum",
                                                                                                                                                                                                "tourist_attraction",
                                                                                                                                                                                                "point_of_interest",
                                                                                                                                                                                                "establishment"
                                                                                                                                                                                             ], photo_ref: "", image_url: [
                                                                                                                                                                                                "https://s3-eu-north-1.amazonaws.com/sayahatai/places/Almaty/central_state_museum_of_the_republic_of_kazakhstan.png"
                                                                                                                                                                                             ]), ActivityMapModel(place_name: "Central State Museum of the Republic of Kazakhstan", address: "Samal-1, 44, Almaty 050059, Kazakhstan", place_description: "The Central State Museum of the Republic of Kazakhstan is the largest museum in Kazakhstan, showcasing the country\'s rich history and cultural heritage. It houses a vast collection of artifacts, including archaeological finds, traditional crafts, and works of art.", coordinates:
                                                                                                                                                                                                                    ["lat": 43.242387,
                                                                                                                                                                                                                     "lng": 76.93013], website: "http://csmrk.kz/", contact_number: "8 (7272) 64 26 80", rating: 4.3, rating_count: 2487, activity_types: [
                                                                                                                                                                                                                        "museum",
                                                                                                                                                                                                                        "tourist_attraction",
                                                                                                                                                                                                                        "point_of_interest",
                                                                                                                                                                                                                        "establishment"
                                                                                                                                                                                                                     ], photo_ref: "", image_url: [
                                                                                                                                                                                                                        "https://s3-eu-north-1.amazonaws.com/sayahatai/places/Almaty/central_state_museum_of_the_republic_of_kazakhstan.png"
                                                                                                                                                                                                                     ])])])
    }
}
