//
//  SuppliersView.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import SwiftUI

struct SuppliersView: View {
    @State private var suppliers = [Supplier]() // Assume Supplier conforms to Identifiable

    @State var companyName: String = ""
    @State var contactName: String = ""
    @State var address: String = ""
    @State var phone: String = ""
    @State var showAddSupplierSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Group {
                if suppliers.isEmpty {
                    Text("Нет записей")
                        .navigationTitle("Поставщики")
                } else {
                    List(suppliers, id: \.supplierID) { supplier in
                        NavigationLink(destination: SupplierDetailsView(supplier: supplier)) {
                            Text(supplier.companyName)
                        }
                    }
                    .navigationTitle("Поставщики")
                }
            }
            .navigationTitle("Поставщики")
            .toolbar {
                Button("", systemImage: "plus") {
                    showAddSupplierSheet = true
                }
            }
            .sheet(isPresented: $showAddSupplierSheet) {
                   NavigationView {
                       Form {
                           TextField("Имя компании", text: $companyName)
                           TextField("Имя контакта", text: $contactName)
                           TextField("Адрес", text: $address)
                           TextField("Телефон", text: $phone)
                           Button("Добавить") {
                               addSupplier()
                               loadSuppliers()
                           }
                       }
                       .navigationTitle("Новый поставщик")
                       .toolbar {
                           ToolbarItem(placement: .navigationBarTrailing) {
                               Button("Закончить") {
                                   showAddSupplierSheet = false
                               }
                           }
                       }
                   }
               }
        }
        .onAppear {
            loadSuppliers()
        }
    }

    func loadSuppliers() {
        suppliers = DatabaseWrapper.shared.getData(tableName: Supplier.self)
    }
    
    func addSupplier() {
        let insertQuery = """
            INSERT INTO Suppliers (CompanyName, ContactName, Address, Phone)
            VALUES ('\(companyName)', '\(contactName)', '\(address)', '\(phone)');
        """
        DatabaseWrapper.shared.executeQuery(with: insertQuery)
    }
}


#Preview {
    SuppliersView()
}
