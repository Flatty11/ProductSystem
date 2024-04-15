//
//  PricingOfferModel.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import Foundation
import SQLite

struct PricingOffer: DatabaseModel {
    let offerID: Int64
    var productID: Int64
    var newPrice: Double
    var discount: Double?
    var startDate: Date
    var endDate: Date
    
    init(with row: Statement.Element) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust as necessary

        offerID = row[0] as! Int64
        productID = row[1] as! Int64
        newPrice = row[2] as! Double
        discount = row[3] as? Double
        startDate = dateFormatter.date(from: row[4] as! String)!
        endDate = dateFormatter.date(from: row[5] as! String)!
    }
}
