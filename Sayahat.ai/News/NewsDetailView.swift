//
//  NewsDetailView.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 02.08.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            // Add custom actions if needed
        }) {
            HStack {
                Image(systemName: "arrow.backward")
            }
        }
    }
}

struct NewsDetailView: View {
    var title: String
    var image_url: String
    var author: String
    var published_date: String
    var url: String
    var text_list: [String]
    var body: some View {
            ScrollView(showsIndicators: false){
                VStack(spacing: 16){
                    HStack(spacing: 16){
                        HStack{
                            Image(systemName: "person")
                            Text(author)
                        }
                        HStack{
                            Image(systemName: "calendar")
                            Text(published_date)
                        }
                    }
                    Text(text_list[0])
                        .font(.subheadline)
                    WebImage(url: URL(string: image_url))
                        .resizable()
                        .scaledToFill()
                    //                    .frame(width: 350)
                        .cornerRadius(16)
                    VStack(alignment: .leading, spacing: 10){
                        ForEach(1..<text_list.count, id: \.self) { index in
                            Text(text_list[index])
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Text("Read more on the website")
                        .foregroundColor(.cyan)
                        .onTapGesture {
                            openWebsite()
                        }
                }
            }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                            ToolbarItem(placement: .principal) {
                                    Text(title).font(.headline)
                                        .lineLimit(4)
                                        .multilineTextAlignment(.leading)
                            }
                        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
}
}

extension NewsDetailView{
    private func openWebsite() {
        guard let url = URL(string: url) else { return }
        
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

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(title: "AERC Forecasts Kazakhstan’s Economic Growth to Reach 4.4% in 2023", image_url: "https://astanatimes.com/wp-content/uploads/2023/08/IMG_3040.jpeg", author: "Saniya Sakenova", published_date: "2 August 2023", url: "https://astanatimes.com/2023/08/aerc-forecasts-kazakhstans-economic-growth-to-reach-4-4-in-2023/", text_list: [
            "ASTANA – The Applied Economics Research Centre (AERC) improved its forecast of Kazakhstan’s gross domestic product (GDP) growth to 4.4% in its macroeconomic review published on July 31.",
            "Photo credit: influencive.com.",
            "Kazakhstan has experienced significant external shocks related to the Russia-Ukraine conflict and internal challenges, including the fires in the Abai Region that claimed the lives of 14 people.",
            "In the first half of the year, the country’s economy grew due to the non-tradable sectors, including construction, trade, and communications, while the real sector still saw moderate growth.",
            "In June, annual inflation slowed to 14.6%, reducing price rises in Kazakhstan. However, intending to protect the domestic market from fuel outflow to neighboring countries due to price disparity, the government raised the maximum prices for petroleum products in April.",
            "“This will lead to soaring prices in all chains of goods, services, and jobs,” reads the report.",
            "According to the baseline scenario, the AERC predicts average inflation to rise to 11.2% due to higher fuel prices.",
            "Established in 2010, the Astana-based AERC carries out scientific, educational and administrative functions to provide legal, analytical and other consulting assistance. With authoritative contacts in various sectors of Kazakhstan’s economy, the AERC specializes in providing comprehensive consulting services in business and public administration."
          ])
    }
}
