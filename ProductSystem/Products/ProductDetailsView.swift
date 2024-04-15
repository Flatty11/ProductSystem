//
//  ProductDetailsView.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import SwiftUI

struct ProductDetailsView: View {
    var product: Product
    @State private var category: String?
    @State private var inventory: [Inventory] = []
    @State private var pricingOffers: [PricingOffer] = []
    
    var body: some View {
        List {
            Text("Наименование: \(product.name)")
            Text("Описание: \(product.description ?? "No description")")
            Text("Цена: \(product.price, specifier: "%.2f")")
            if let category {
                Text("Категория: \(category)")
            }
            Section(header: Text("Детали инвентаря")) {
                Button("Добавить запись", systemImage: "plus") {
                    addInventory()
                }
                ForEach(inventory, id: \.inventoryID) { item in
                    VStack(alignment: .leading) {
                        Text("Количество: \(item.quantity)")
                        Text("Дата последнего обновления: \(item.lastStockUpdate, formatter: itemFormatter)")
                    }
                }
            }
            Button("Добавить скидку", systemImage: "plus") {
                addPriceOffer()
            }
            if pricingOffers.isEmpty == false {
                ForEach(pricingOffers, id: \.offerID) { offer in
                    Section(header: Text("Детали предложения \(offer.offerID)")) {
                        Text("Новая цена: \(offer.newPrice, specifier: "%.2f")")
                        Text("Скидка: \(offer.discount ?? 0, specifier: "%.2f")")
                        Text("Дата начала: \(offer.startDate, formatter: itemFormatter)")
                        Text("Дата окончания: \(offer.endDate, formatter: itemFormatter)")
                    }
                }
            } else {
                Text("Цена не менялась")
            }
        }
        .navigationTitle(product.name)
        .onAppear {
            fetchData()
        }
    }
    
    func addInventory() {
        let quantity: Int = Int.random(in: 1...60)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = dateFormatter.string(from: Date())
        let insertInventory = """
        INSERT INTO Inventory (ProductID, Quantity, LastStockUpdate)
        VALUES
        (\(product.productID), \(quantity), '\(currentDate)');
        """
        DatabaseWrapper.shared.executeQuery(with: insertInventory)
        fetchInventory()
    }
    
    func addPriceOffer() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = dateFormatter.string(from: Date())
        let endDate = dateFormatter.string(from: .now + TimeInterval(60*Int.random(in: 0...1000)))
        let newPrice = Double.random(in: 10...60)
        let discount = Double.random(in: 1...15)
        let insertPrice = """
        INSERT INTO PricingOffers (ProductID, NewPrice, Discount, StartDate, EndDate)
        VALUES
        (\(product.productID), \(newPrice), \(discount), '\(currentDate)', '\(endDate)');
        """

        DatabaseWrapper.shared.executeQuery(with: insertPrice)
        fetchPricingOffers()
    }
    
    func fetchInventory() {
        let inventoryQuery = "SELECT * FROM Inventory WHERE ProductID = \(product.productID);"
        let result = DatabaseWrapper.shared.performQuery(with: inventoryQuery)
        guard let result else {
            print("ошибка")
            return
        }
        inventory = result.map{ item in
           .init(with: item)
        }
    }
    
    func fetchPricingOffers() {
        let priceQuery = "SELECT * FROM PricingOffers WHERE ProductID = \(product.productID);"
        let priceResult = DatabaseWrapper.shared.performQuery(with: priceQuery)
        guard let priceResult else {
            print("ошибка")
            return
        }
        pricingOffers = priceResult.map{ item in
           .init(with: item)
        }
    }
    
    func fetchData() {
        let categoryQuery = "SELECT CategoryName FROM Categories WHERE CategoryID = \(product.categoryID);"
        let res = DatabaseWrapper.shared.performQuery(with: categoryQuery)
        guard let res else {
            print("ошибка")
            return
        }
        for cat in res {
            category = cat[0] as? String
        }
        
        fetchInventory()
        fetchPricingOffers()
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    ProductDetailsView(product: .init())
}
