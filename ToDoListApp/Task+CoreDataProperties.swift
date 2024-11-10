//
//  Task+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by Naufal Qathafa Rasya Hidayat on 28/06/24.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var task: String?
    @NSManaged public var id: UUID?

}

extension Task : Identifiable {

}
