//
//  SupplierDetailsView.swift
//  ProductSystem
//
//  Created by Илья on 09.04.2024.
//

import Foundation
import SwiftUI

struct SupplierDetailsView: View {
    let supplier: Supplier
    @State var history: [SupplyHistory] = []
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("**Адрес поставщика**: \(supplier.address!)")
                Text("**Имя контактного лица**: \(supplier.contactName!)")
                Text("**Телефонный номер**: \(supplier.phone!)")
            }
            Button("Добавить запись о поставке", systemImage: "plus") {
                addHistorySupply()
            }
            ForEach(history, id: \.SupplyHistoryID) { history in
                VStack(alignment: .leading) {
                    Text("**Количество**: \(history.quantitySupplied)")
                    Text("**Дата поставки**: \(history.supplyDate)")
                }
            }
        }
        .navigationTitle(supplier.companyName)
        
        .onAppear {
            fetchData()
        }
    }
    
    func addHistorySupply() {
        let supply = Int.random(in: 100...500)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = dateFormatter.string(from: Date())
        
        let productIDsQuery = """
        SELECT ProductID FROM Products WHERE SupplierID = \(supplier.supplierID)
        """
        
        let result = DatabaseWrapper.shared.performQuery(with: productIDsQuery)
        guard let result else { return }
        
        let productIDs = result.map { res in
            return res[0] as! Int64
        }
        
        print(productIDs)
        
        let insertQuery: String = """
            INSERT INTO SupplyHistory (SupplierID, ProductID, QuantitySupplied, SupplyDate)
            VALUES
            (\(supplier.supplierID), \(productIDs.randomElement() ?? 1), \(supply), '\(currentDate)');
            """
        
        DatabaseWrapper.shared.executeQuery(with: insertQuery)
        fetchData()
    }
    
    func fetchData() {
        let historyQuery = """
        SELECT * FROM SupplyHistory WHERE SupplierID = \(supplier.supplierID);"
        """
        let result = DatabaseWrapper.shared.performQuery(with: historyQuery)
        guard let result else { return }
        self.history = result.map { res in
            .init(with: res)
        }
    }
}
