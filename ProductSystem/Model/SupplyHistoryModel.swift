//
//  SupplyHistoryModel.swift
//  ProductSystem
//
//  Created by Илья on 09.04.2024.
//

import Foundation
import SQLite

struct SupplyHistory: DatabaseModel {
    let SupplyHistoryID: Int64
    var supplierID: Int64
    var productID: Int64
    var quantitySupplied: Int64
    var supplyDate: Date
    
    init(with row: Statement.Element) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust as necessary

        SupplyHistoryID = row[0] as! Int64
        supplierID = row[1] as! Int64
        productID = row[2] as! Int64
        quantitySupplied = row[3] as! Int64
        supplyDate = dateFormatter.date(from: row[4] as! String)!
    }
}
