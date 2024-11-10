//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by Naufal Qathafa Rasya Hidayat on 28/06/24.
//

import SwiftUI

@main
struct ToDoListAppApp: App {
    
    @StateObject private var manager : DataManager = DataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
            //coredata
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
