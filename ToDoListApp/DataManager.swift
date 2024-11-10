//
//  DataManager.swift
//  ToDoListApp
//
//  Created by Naufal Qathafa Rasya Hidayat on 28/06/24.
//

import Foundation
import CoreData

class DataManager : NSObject, ObservableObject {
    
    @Published var todos : [Task] = [Task]()
    
    let container : NSPersistentContainer = NSPersistentContainer(name: "ToDoListApp")
    
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in}
    }
}
