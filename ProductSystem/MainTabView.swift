//
//  MainTabView.swift
//  ProductSystem
//
//  Created by Илья on 07.04.2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ProductsView()
                .tabItem {
                    Label("Продукты", systemImage: "cart")
                }
            CategoriesView()
                .tabItem {
                    Label("Категории", systemImage: "list.bullet")
                }
            SuppliersView()
                .tabItem {
                    Label("Поставщики", systemImage: "person.3")
                }
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainTabView()
}
