//
//  CategoryModel.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import Foundation
import SQLite

struct Categorie: DatabaseModel {
    let categoryID: Int64
    var name: String
    var description: String?
    
    init(with row: Statement.Element) {
        categoryID = row[0] as! Int64
        name = row[1] as! String
        description = row[2] as? String
    }
}
