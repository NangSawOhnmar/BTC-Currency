//
//  ApiEndpoint.swift
//  BTC Currency
//
//  Created by nang saw on 24/09/2022.
//

struct ApiEndpoint{
    static var baseUrl: String{
        return "https://api.coindesk.com/v1/"
    }
    
    static let BPI: String = "\(baseUrl)bpi/currentprice.json"
}
