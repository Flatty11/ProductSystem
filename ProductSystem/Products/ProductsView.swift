//
//  ProductsView.swift
//  ProductSystem
//
//  Created by Илья on 06.04.2024.
//

import SwiftUI

struct ProductsView: View {
    @StateObject var viewModel: ProductViewModel = .init()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.products.isEmpty {
                    Text("Нет записей")
                } else {
                    List(viewModel.products, id: \.productID) { product in
                        NavigationLink(destination: ProductDetailsView(product: product)) {
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .font(.headline)
                                Text(product.description ?? "Нет описания")
                                    .font(.subheadline)
                                HStack {
                                    Text("Цена: \(product.price, specifier: "%.2f")")
                                    Spacer()
                                    Text("В наличии: \(product.stockLevel)")
                                }
                                .font(.caption)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadProducts()
            }
            .navigationTitle("Продукты")
            .toolbar {
                Button("", systemImage: "plus") {
                    viewModel.fetchSuppliers()
                    viewModel.fetchCategories()
                    viewModel.showAddProductSheet = true
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddProductSheet) {
            NavigationView {
                Form {
                    TextField("Наименование продукта", text: $viewModel.productName)
                    TextField("Описания", text: $viewModel.productDescription)
                    TextField("Цена", value: $viewModel.productPrice, formatter: NumberFormatter())
                    TextField("В наличии", value: $viewModel.productStockLevel, formatter: NumberFormatter())
                    Picker("Категория", selection: $viewModel.selectedCategoryId) {
                        Text("Не выбрано").tag(Int64?.none)
                        ForEach(viewModel.categories, id: \.categoryID) { category in
                            Text(category.name).tag(category.categoryID as? Int64)
                        }
                    }
                    Picker("Поставщик", selection: $viewModel.selectedSupplierId) {
                        Text("Не выбрано").tag(Int64?.none)
                        ForEach(viewModel.suppliers, id: \.supplierID) { supplier in
                            Text(supplier.companyName).tag(supplier.supplierID as? Int64)
                        }
                    }
                    Button("Добавить продукт") {
                        viewModel.addProduct()
                    }
                    .disabled(viewModel.selectedCategoryId == nil || viewModel.selectedSupplierId == nil)
                }
                .navigationTitle("Новый продукт")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("ОК") {
                            viewModel.showAddProductSheet = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProductsView()
}
