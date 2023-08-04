//
//  NewsViewModel.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 02.08.2023.
//

import SwiftUI
import Foundation
import Moya

struct NewsModel:  Codable{
    let _id: String
    let url: String
    let title: String
    let author: String
    let published_date: String
    let text_list: [String]
    let image_url: String
}

extension NewsModel: Identifiable, Hashable{
    
    var id: String{
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher){
        return hasher.combine(id)
    }
    
    public static func == (lhs: NewsModel, rhs: NewsModel) -> Bool{
        return lhs.id == rhs.id
    }
}

struct News: Codable{
    let news: [NewsModel]
}




class NewsViewModel: ObservableObject{
    @Published var news: [NewsModel] = []
    let provider = MoyaProvider<NewsService>()
    
    func fetchNews(){
        provider.request(.getNews){ result in
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    do{
                        let data = try response.map(News.self)
                        print("News fetching succesful")
                        self.news = data.news
                    }catch{
                        print("error decoding json: \(error.localizedDescription)")
                    }
                }else{
                    print("Trips fetching failed. Response: \(response)")
                }
            case .failure(let error):
                print("Error while fetching news: \(error.localizedDescription)")
            }
            
        }
    }
}

