//
//  DatabaseWrapper.swift
//  ProductSystem
//
//  Created by Илья on 06.04.2024.
//

import Foundation
import SQLite

class DatabaseWrapper: ObservableObject {
    static let shared = DatabaseWrapper()
    
    private let db: Connection
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        db = try! Connection("\(path)/db.sqlite3")
        
//        createTables()
//        fillTables()
    }
    
    func deleteData() {
        do {
            try db.transaction {
                try db.run("DELETE FROM Products")
                try db.run("DELETE FROM Categories")
                try db.run("DELETE FROM Suppliers")
                try db.run("DELETE FROM Inventory")
                try db.run("DELETE FROM PricingOffers")
                try db.run("DELETE FROM SupplyHistory")
            }
            print("All data deleted successfully within a transaction.")
        } catch {
            print("Transaction failed: \(error)")
        }
    }
    
    func fillTables() {
        do {
            let insertCategories = """
            INSERT INTO Categories (CategoryName, Description)
            VALUES
            ('Фрукты', 'Все виды фруктов'),
            ('Овощи', 'Различные овощи для вашего стола'),
            ('Напитки', 'Горячие и холодные напитки');
            """
            try db.execute(insertCategories)
            
            let insertSuppliers = """
            INSERT INTO Suppliers (CompanyName, ContactName, Address, Phone)
            VALUES
            ('ООО "Фруктовый Рай"', 'Иван Иванов', 'г. Москва, ул. Ленина, д. 10', '+71234567890'),
            ('Зеленый Огород', 'Светлана Петрова', 'г. Санкт-Петербург, ул. Мира, д. 20', '+79876543210'),
            ('Напитки от Павла', 'Павел Васильев', 'г. Новосибирск, ул. Сибирская, д. 30', '+72345678901');
            """
            try db.execute(insertSuppliers)
            
            let insertProducts = """
            INSERT INTO Products (Name, Description, Price, CategoryID, SupplierID, StockLevel)
            VALUES
            ('Яблоко', 'Свежие яблоки сорта Голден', 60.50, 1, 1, 150),
            ('Морковь', 'Органическая морковь без добавок', 40.00, 2, 2, 200),
            ('Чай черный', 'Листовой чай высшего качества', 150.00, 3, 3, 100);
            """
            try db.execute(insertProducts)
            print("Inserted data into the Products table successfully.")
            
            let insertInventory = """
            INSERT INTO Inventory (ProductID, Quantity, LastStockUpdate)
            VALUES
            (1, 150, '2023-09-01'),
            (2, 200, '2023-09-01'),
            (3, 100, '2023-09-01');
            """
            try db.execute(insertInventory)
            let insertSupplyHistory = """
            INSERT INTO SupplyHistory (SupplierID, ProductID, QuantitySupplied, SupplyDate)
            VALUES
            (1, 1, 150, '2023-09-01'),
            (2, 2, 200, '2023-09-02'),
            (3, 3, 100, '2023-09-03');
            """
            try db.execute(insertSupplyHistory)
            
            let insertPricingOffers = """
            INSERT INTO PricingOffers (ProductID, NewPrice, Discount, StartDate, EndDate)
            VALUES
            (1, 55.00, 5.50, '2023-10-01', '2023-10-31'),
            (2, 35.00, 5.00, '2023-10-05', '2023-10-25'),
            (3, 140.00, 10.00, '2023-10-10', '2023-11-10');
            """
            try db.execute(insertPricingOffers)
            
        } catch {
            print("An error occurred: \(error)")
        }
    }
    
    func getData<T: DatabaseModel>(tableName: T.Type, addPlural: Bool = true) -> [T] {
        do {
            let query = "SELECT * FROM \(String(describing: T.self))\(addPlural ? "s" : "");"
            
            let array: [T] = try db.prepare(query).map { row in
                return .init(with: row)
            }
            return array
        } catch {
            print("An error occurred: \(error)")
            return []
        }
    }
    
}

//MARK: - CREATE
extension DatabaseWrapper {
    func createTables() {
        let createCategoriesTable = """
        CREATE TABLE IF NOT EXISTS Categories (
            CategoryID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            CategoryName TEXT NOT NULL,
            Description TEXT
        );
        """
        createTable(with: createCategoriesTable)
        
        let createSuppliersTable = """
        CREATE TABLE IF NOT EXISTS Suppliers (
            SupplierID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            CompanyName TEXT NOT NULL,
            ContactName TEXT,
            Address TEXT,
            Phone TEXT);
        """
        createTable(with: createSuppliersTable)
        
        let createProductsTable = """
        CREATE TABLE IF NOT EXISTS Products (
            ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
            Name TEXT NOT NULL,
            Description TEXT,
            Price REAL NOT NULL,
            CategoryID INTEGER NOT NULL,
            SupplierID INTEGER NOT NULL,
            StockLevel INTEGER NOT NULL,
            FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
            FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
        );
        """
        createTable(with: createProductsTable)
        
        let createInventoryTable = """
        CREATE TABLE IF NOT EXISTS Inventory (
            InventoryID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ProductID INTEGER NOT NULL,
            Quantity INTEGER NOT NULL,
            LastStockUpdate DATETIME NOT NULL,
            FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        );
        """
        createTable(with: createInventoryTable)
        let createPricingOffersTable = """
        CREATE TABLE IF NOT EXISTS PricingOffers (
            OfferID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ProductID INTEGER NOT NULL,
            NewPrice REAL NOT NULL,
            Discount REAL,
            StartDate DATETIME NOT NULL,
            EndDate DATETIME NOT NULL,
            FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        );
        """
        createTable(with: createPricingOffersTable)
        let createSupplyHistoryTable = """
        CREATE TABLE IF NOT EXISTS SupplyHistory (
            SupplyID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            SupplierID INTEGER NOT NULL,
            ProductID INTEGER NOT NULL,
            QuantitySupplied INTEGER NOT NULL,
            SupplyDate DATETIME NOT NULL,
            FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
            FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        );
        """
        createTable(with: createSupplyHistoryTable)
    }
    
    private func createTable(with query: String) {
        do {
            try db.execute(query)
            print("Table created successfully.")
        } catch {
            print("Error creating table: \(error)")
        }
    }
    
    func performQuery(with query: String) -> Statement? {
        do {
            let res = try db.prepare(query)
            print("performQuery successfully.")
            return res
        } catch {
            print("Error creating table: \(error)")
            return nil
        }
    }
    
    func executeQuery(with query: String) {
        do {
            try db.execute(query)
            print("execute successfully.")
        } catch {
            print("Error execute: \(error)")
        }
    }
    
}
