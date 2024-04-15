//
//  CategoriesView.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import SwiftUI

struct CategoriesView: View {
    @State private var categories = [Categorie]() // Assume Category conforms to Identifiable
    @State var categoryName: String = ""
    @State var categoryDescription: String = ""
    @State var showAddCategorySheet: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if categories.isEmpty {
                    Text("Нет записей")
                } else {
                    List(categories, id: \.categoryID) { category in
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.headline)
                            Text(category.description ?? "Нет описания")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Категории")
            .toolbar {
                Button("", systemImage: "plus") {
                    showAddCategorySheet = true
                }
            }
        }
        .onAppear {
            loadCategories()
        }
        .sheet(isPresented: $showAddCategorySheet) {
            NavigationView {
                Form {
                    TextField("Имя категории", text: $categoryName)
                    TextField("Описание", text: $categoryDescription)
                    Button("Добавить") {
                        addCategory()
                    }
                }
                .navigationTitle("Новая категория")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Закончить") {
                            loadCategories()
                            showAddCategorySheet = false
                        }
                    }
                }
            }
        }
    }

    func loadCategories() {
        categories = DatabaseWrapper.shared.getData(tableName: Categorie.self)
    }
    
    func addCategory() {
        let insertQuery: String = """
        INSERT INTO Categories (CategoryName, Description)
        VALUES ('\(categoryName)', '\(categoryDescription)')
        """
        
        DatabaseWrapper.shared.executeQuery(with: insertQuery)
    }
}


#Preview {
    CategoriesView()
}
