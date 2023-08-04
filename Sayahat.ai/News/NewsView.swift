//
//  NewsView.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 02.08.2023.
//

import SwiftUI
import SDWebImageSwiftUI

func getDateFormatter(for timezoneIdentifier: String) -> DateFormatter{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
    return dateFormatter
}

struct NewsItemView: View{
    let imageUrl: String
    let title: String
    let textBody: String
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 160)
                .foregroundColor(Color.gray.opacity(0.3))
            HStack{
                
                WebImage(url: URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                VStack(alignment: .leading, spacing: 6){
                    Text(title)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(.black)
                    Text(textBody)
                        .font(.caption)
                        .lineLimit(3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                .frame(height: 160)
            }
        }
    }
}

struct NewsView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @StateObject var newsVM: NewsViewModel = NewsViewModel()
    @State var astanaTime = getDateFormatter(for: "Kazakhstan/Astana").string(from: Date())
    @State var aktobeTime = getDateFormatter(for: "Asia/Aqtau").string(from: Date())
    private let timer = Timer.publish(every: 1, on: .main,in: .common ).autoconnect()
    
    
    var body: some View {
            VStack(alignment: .center, spacing: 20){
                dateComponent
                timeContainer
                VStack{
                    Text("Recent news in Kazakhstan")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity)
                    if networkMonitor.isConnected{
                        ScrollView(showsIndicators: false){
                            if newsVM.news == []{
                                ProgressView()
                            }else{
                                VStack{
                                    ForEach(newsVM.news, id: \.id){
                                        newsItem in
                                        NavigationLink(value: SelectionState.news(newsItem)){
                                            NewsItemView(imageUrl: newsItem.image_url, title: newsItem.title, textBody: newsItem.text_list[2])
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }else{
                        Text("No internet connection. Please connect to the internet and try again")
                            .font(.callout.bold())
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                .frame(maxHeight:600)
            }
            
        .padding(.horizontal)
        .onAppear{
            newsVM.fetchNews()
            
        }
        .onReceive(timer){_ in
            astanaTime = getDateFormatter(for: "Kazakhstan/Astana").string(from: Date())
            aktobeTime = getDateFormatter(for: "Asia/Aqtau").string(from: Date())
        }
    }
}



extension NewsView{
    private var dateComponent: some View{
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 160, height: 40)
                .foregroundColor(Color.gray.opacity(0.3))
            HStack{
                Image(systemName: "calendar.circle")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)
                Text(getTodaysDate())
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    private var timeContainer: some View{
        VStack(spacing: 16){
            HStack{
                Text("Time in Kazakhstan cities")
                    .font(.title.bold())
                Spacer()
            }
            VStack(spacing: 6){
                HStack{
                    Text("Astana, Almaty, Shymkent")
                    Spacer()
                    Text(astanaTime)
                }
                HStack{
                    Text("Atyrau, Aktobe, Aqtau")
                    Spacer()
                    Text(aktobeTime)
                }
            }
        }
        
    }
    
    
    private func getTodaysDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let today = Date()
        return dateFormatter.string(from: today)
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
