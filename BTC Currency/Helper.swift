//
//  Helper.swift
//  BTC Currency
//
//  Created by nang saw on 24/09/2022.
//

import SwiftDate

class Helper{
    class func formatISODateTime(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxx"
         dateFormatter.timeZone = TimeZone.current
        let timestamp = dateFormatter.date(from: date)
        return timestamp ?? Date()
    }

    class func stringToTimeAndDate(date: String) -> String {
        let dateInRegion = DateInRegion(Helper.formatISODateTime(date: date), region: Region.current)
        let date = dateInRegion.toFormat("hh:mm a '|' dd MMM','yyyy")
        return date
    }

}
