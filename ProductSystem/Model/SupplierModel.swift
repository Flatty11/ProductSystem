//
//  SupplierModel.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import Foundation
import SQLite

struct Supplier: DatabaseModel {
    let supplierID: Int64
    var companyName: String
    var contactName: String?
    var address: String?
    var phone: String?
    
    init(with row: Statement.Element) {
        supplierID = row[0] as! Int64
        companyName = row[1] as! String
        contactName = row[2] as? String
        address = row[3] as? String
        phone = row[4] as? String
    }
}
