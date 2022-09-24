//
//  Client.swift
//  BTC Currency
//
//  Created by nang saw on 24/09/2022.
//

import Alamofire

class Client{
    var sessionManager: Alamofire.Session!
    typealias completion = (_ response: AFDataResponse<Data>) -> Void
    typealias RequestAdaptCompletion = (_ urlRequest: URLRequest) -> Void
    typealias uploadProgress = (_ progress: Double) -> Void
    
    init() {
        sessionManager = Alamofire.Session(configuration: URLSessionConfiguration.default)
    }

    init (config: URLSessionConfiguration = URLSessionConfiguration.default){
        sessionManager = Alamofire.Session(configuration: config)
    }

    func request(_ request: URLRequest,requestInterceptor: RequestInterceptor? = nil,_ completion: @escaping completion){
        sessionManager = Alamofire.Session(interceptor: requestInterceptor)
        sessionManager.session.configuration.httpShouldUsePipelining = true
        sessionManager.request(request).responseData { (response) in
            completion(response)
        }
    }
    
}
