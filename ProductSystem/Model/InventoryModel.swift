//
//  InventoryModel.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import Foundation
import SQLite

struct Inventory: DatabaseModel {
    let inventoryID: Int64
    var productID: Int64
    var quantity: Int64
    var lastStockUpdate: Date
    
    init(with row: Statement.Element) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust as necessary

        inventoryID = row[0] as! Int64
        productID = row[1] as! Int64
        quantity = row[2] as! Int64
        lastStockUpdate = dateFormatter.date(from: row[3] as! String)!
    }
}
