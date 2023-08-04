//
//  ActivityDetailsView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 03.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActivityDetailsView: View {
    var title: String
    var imageUrl: [String]
    var address: String
    var contactNumber: String?
    var rating: Float
    var activityTypes: [String]
    var website: String?
    var description: String
    var coordinates: [String: Float]
    var body: some View {
        VStack{
            ZStack(alignment: .bottomLeading){
                imageContainer
                
                VStack{
                    titleContainer
                    addressContainer
                    activityTypesContainer
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 8)
            }.ignoresSafeArea()
                .frame(height: 450)
            ZStack{
                VStack(spacing: 10){
                    descriptionContainer
                    Divider()
                    ratingContainer
                    Divider()
                    contactsContainer
                    Spacer()
                }
            }.padding(.horizontal)
            Spacer()
        }
        .ignoresSafeArea()
        
    }
}

extension ActivityDetailsView{
    private var imageContainer: some View{
        TabView{
            ForEach(imageUrl, id:\.self){
                url in
                WebImage(url: URL(string: url))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .ignoresSafeArea()
        .padding(.top, -60)
        .frame(height: 450)
        .tabViewStyle(PageTabViewStyle())
        
    }
    
    private var titleContainer: some View{
        HStack{
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .frame(height: 50)
            Spacer()
        }
    }
    
    private var addressContainer: some View{
        HStack(spacing: 2){
            Image("mappin")
            Text(address)
                .foregroundColor(.white)
                .font(.subheadline)
            Spacer()
        }
    }
    
    private var activityTypesContainer: some View{
        ScrollView(.horizontal){
            HStack(spacing: 16){
                ForEach(getModifiedStrings(strings: activityTypes), id:\.self){ type in
                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 30)
                            .frame(maxWidth: 180)
                            .backgroundStyle(.ultraThinMaterial)
                            .foregroundStyle(                        LinearGradient(colors: [.gray, Color.gray.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                            .padding(.horizontal, -6)
                        Text(type)
                            .font(.subheadline)
                            .frame(maxWidth: 150)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
    
    private var descriptionContainer: some View{
        Text("Description: \(description)")
            .font(.body)
            .fontWeight(.semibold)
            .padding(.horizontal, -4)
    }
    
    private func star(index: Int) -> some View{
        var body: some View {
            let decimalPart = rating - Float(index)
            if decimalPart >= 0.75 {
                return Image(systemName: "star.fill")
            } else if decimalPart >= 0.25 {
                return Image(systemName: "star.lefthalf.fill")
            } else {
                return Image(systemName: "star")
            }
        }
        return body
    }
    
    private var ratingContainer: some View{
        HStack{
            Text("Rating")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.trailing, 20)
            HStack(alignment: .center, spacing: 20){
                HStack(alignment: .center){
                    ForEach(0..<5) { index in
                        star(index: index)
                            .foregroundColor(.yellow)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(width: 100, alignment: .center)
                Text(String(format: "%.1f", rating))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Spacer()
            }.frame(height: 20, alignment: .center)
            Button{
                openWebsite()
            }label:{
                ZStack{
                    Text("Book Now")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 80, height: 30)
                                .foregroundColor(
                                    Color.yellow
                                )
                        }
                    
                }.frame(width: 80, height: 35)
            }
            
        }
    }
    
    private var nullRatingContainer: some View{
        HStack{
            Text("Rating")
                .font(.subheadline)
                .fontWeight(.semibold)
            HStack {
                ForEach(0..<5) { index in
                    star(index: index)
                }
                Text(String("No data"))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
        }
    }
    
    private var contactsContainer: some View{
        HStack{
            if let number = contactNumber{
                Text("Contact: \(number != "" ? number : "No data")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            Spacer()
            HStack{
                Button{
                    makePhoneCall()
                }label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5)
                            .frame(width: 35, height: 35)
                            .foregroundStyle(LinearGradient(colors: [Color.gray, Color.gray.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        Image(systemName: "phone")
                    }
                }
                Button{
                    openGoogleMaps()
                }label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5)
                            .frame(width: 35, height: 35)
                            .foregroundStyle(LinearGradient(colors: [Color.gray, Color.gray.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        Image(systemName: "map")
                    }
                }
            }
        }
        .frame(height: 50, alignment: .leading)
        
    }
    
    
    func getModifiedStrings(strings: [String]) -> [String]{
        let capitalizedStrings = strings.map { string -> String in
            var modifiedString = string.replacingOccurrences(of: "_", with: " ")
            modifiedString = modifiedString.capitalized
            return modifiedString
        }
        return capitalizedStrings
    }
    
    private func openGoogleMaps() {
        
        let latitude: Float = coordinates["lat"]! // Replace with the desired latitude of the location
        let longitude: Float = coordinates["lng"]! // Replace with the desired longitude of the location
        let mapURLString = "comgooglemaps://?q=\(latitude),\(longitude)&center=\(latitude),\(longitude)&zoom=14&views=traffic"
        
        guard let url = URL(string: mapURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let webURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)")!
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            
        }
    }
    
    private func openWebsite() {
        guard let url = URL(string: website!) else { return }
        
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
    
    private func makePhoneCall() {
        guard let contactNumber else {return}
        if let phoneURL = URL(string: "tel://\(contactNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }else{
            showPhoneAlert()
        }
    }
    private func showPhoneAlert() {
        let alert = UIAlertController(title: "Error", message: "Unable to make the phone call.", preferredStyle: .alert)
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

