//
//  ProductModel.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import Foundation
import SQLite

protocol DatabaseModel {
    init(with row: Statement.Element)
}

struct Product: DatabaseModel {
    var productID: Int64
    var name: String
    var description: String?
    var price: Double
    var categoryID: Int64
    var supplierID: Int64
    var stockLevel: Int64
    
    init(with row: Statement.Element) {
        productID = row[0] as! Int64              // Assuming 'id' is the first column
        name = row[1] as! String       // Assuming 'name' is the second column
        description = row[2] as? String  // 'description' may be nil
        price = row[3] as! Double      // and so on...
        categoryID = row[4] as! Int64
        supplierID = row[5] as! Int64
        stockLevel = row[6] as! Int64
    }
    
    init() {
        productID = 1
        name = "Яблоко"
        description = "Самое вкусное"
        price = 20
        categoryID = 50
        supplierID = 250
        stockLevel = 5
    }
}
