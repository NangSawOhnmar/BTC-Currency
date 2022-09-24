//
//  BitcoinPrice.swift
//  BTC Currency
//
//  Created by nang saw on 24/09/2022.
//

import SwiftyJSON

struct BitcoinPrice{
    var time: UpdatedTime!
    var disclaimer: String!
    var chartName: String!
    var bpi: BPI!
    
    static func loadJSON(json: JSON) -> BitcoinPrice{
        var bitcoinPrice = BitcoinPrice()
        bitcoinPrice.time = UpdatedTime.loadJSON(json: json["time"])
        bitcoinPrice.disclaimer = json["disclaimer"].stringValue
        bitcoinPrice.chartName = json["chartName"].stringValue
        bitcoinPrice.bpi = BPI.loadJSON(json: json["bpi"])
        return bitcoinPrice
    }
}

struct UpdatedTime{
    var updated: String!
    var updatedISO: String!
    var updateduk: String!
    
    static func loadJSON(json: JSON) -> UpdatedTime{
        var updatedTime = UpdatedTime()
        updatedTime.updated = json["updated"].stringValue
        updatedTime.updatedISO = json["updatedISO"].stringValue
        updatedTime.updateduk = json["updateduk"].stringValue
        return updatedTime
    }
}

struct BPI{
    var USD: Rate!
    var GBP: Rate!
    var EUR: Rate!
    
    static func loadJSON(json: JSON) -> BPI{
        var bpi = BPI()
        bpi.USD = Rate.loadJSON(json: json["USD"])
        bpi.GBP = Rate.loadJSON(json: json["GBP"])
        bpi.EUR = Rate.loadJSON(json: json["EUR"])
        return bpi
    }
}

struct Rate{
    var code: String!
    var symbol: String!
    var rate: String!
    var description: String!
    var rate_float: Float!
    
    static func loadJSON(json: JSON) -> Rate{
        var rate = Rate()
        rate.code = json["code"].stringValue
        rate.symbol = json["symbol"].stringValue
        rate.rate = json["rate"].stringValue
        rate.description = json["description"].stringValue
        rate.rate_float = json["rate_float"].floatValue
        return rate
    }
}

enum Currency: String{
    case USD = "USD"
    case GBP = "GBP"
    case EUR = "EUR"
}
