//
//  CustomMoyaProvider.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 27.07.2023.
//

import Foundation
import Moya


class CustomMoyaProvider<Target>: MoyaProvider<Target> where Target: TargetType{
    init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        
        let session = Session(configuration: configuration)
        let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<Target>.RequestResultClosure) in
            do {
                let request = try endpoint.urlRequest()
                
                done(.success(request))
            }catch{
                done(.failure(MoyaError.underlying(error, nil)))
            }
            
        }
        
        super.init(requestClosure: requestClosure, session: session, plugins: [])
    }
}
