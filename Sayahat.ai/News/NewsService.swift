//
//  NewsService.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 02.08.2023.
//

import Foundation
import Moya
import Alamofire



enum NewsService{
    case getNews
}

extension NewsService: TargetType{
    
    var baseURL: URL {
        URL(string: "https://sayahatai-backend.onrender.com/news")!
        
    }
    
    var method: Moya.Method {
        switch self{
        case .getNews:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .getNews:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    
    var path: String{
        switch self{
        case .getNews:
            return "/"
        }
        
    }
    
    var task: Moya.Task {
        switch self{
        case .getNews:
            return .requestPlain
        }
        
    }
    
}
