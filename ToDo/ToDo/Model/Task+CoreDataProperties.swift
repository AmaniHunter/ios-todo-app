//
//  Task+CoreDataProperties.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateCompleted: Date?
    @NSManaged public var itemDescription: String?
    @NSManaged public var isCompleted: Bool

}

extension Task : Identifiable {

}
