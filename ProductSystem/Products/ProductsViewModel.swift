//
//  ProductsViewModel.swift
//  ProductSystem
//
//  Created by Илья on 08.04.2024.
//

import Foundation
import Combine
import SQLite

class ProductViewModel: ObservableObject {
    var db: DatabaseWrapper = DatabaseWrapper.shared
    @Published var products = [Product]()
    
    @Published var productName: String = ""
    @Published var productDescription: String = ""
    @Published var productPrice: Double = 0.0
    @Published var productStockLevel: Int = 0
    @Published var selectedCategoryId: Int64?
    @Published var selectedSupplierId: Int64?
    @Published var categories: [Categorie] = []
    @Published var suppliers: [Supplier] = []
    
    @Published var showAddProductSheet: Bool = false

    init() {
        loadProducts()
    }
    
    func loadProducts() {
        products = DatabaseWrapper.shared.getData(tableName: Product.self)
    }

    func fetchCategories() {
        categories = DatabaseWrapper.shared.getData(tableName: Categorie.self)
        print(categories.map(\.categoryID))
    }

    func fetchSuppliers() {
        suppliers = DatabaseWrapper.shared.getData(tableName: Supplier.self)
        print(suppliers.map(\.supplierID))
    }

    func addProduct() {
        let insertStatement = """
        INSERT INTO Products (Name, Description, Price, CategoryID, SupplierID, StockLevel)
        VALUES
        ('\(productName)', '\(productDescription)', \(productPrice), \(selectedCategoryId!), \(selectedSupplierId!), \(productStockLevel));
        """

        print(insertStatement)
        DatabaseWrapper.shared.executeQuery(with: insertStatement)
        loadProducts()
        showAddProductSheet = false // Закрыть форму после добавления
    }
}
