//
//  SettingsView.swift
//  ProductSystem
//
//  Created by Илья on 06.04.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    DatabaseWrapper.shared.createTables()
                }, label: {
                    Text("Создать таблицы")
                })
                Button(action: {
                    DatabaseWrapper.shared.fillTables()
                }, label: {
                    Text("Заполнить таблицы")
                })
                Button(action: {
                    DatabaseWrapper.shared.deleteData()
                }, label: {
                    Text("Удалить все данные")
                })
            }
            .navigationTitle("Настройки")
        }
    }
}

#Preview {
    SettingsView()
}
