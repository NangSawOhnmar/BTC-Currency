//
//  Request.swift
//  BTC Currency
//
//  Created by nang saw on 24/09/2022.
//

import Alamofire
import SwiftyJSON

class Requests: Router{
    typealias successBlock = (_ responseJSON: JSON) -> Void
    typealias failBlock = (_ error: JSON) -> Void
    
    init() {
        super.init(client: Client())
    }
    
    func getBPI(success: @escaping successBlock, fail: @escaping failBlock){
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: ApiEndpoint.BPI){
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                super.request(urlRequest: request, params: nil, nil, encoding: JSONEncoding.default, success: { json in
                    success(json)
                }, fail: { error in
                    fail(error)
                })
            }
        }
    }
}
