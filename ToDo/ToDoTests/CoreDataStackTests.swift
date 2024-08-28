//
//  CoreDataStackTests.swift
//  ToDoTests
//
//  Created by Amani Hunter on 8/27/24.
//

import XCTest
import CoreData
@testable import ToDo

class CoreDataStackTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    override func setUp() {
        super.setUp()
        
        // Setup an in-memory store for testing without accessing storeContainer directly
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        // Initialize CoreDataStack as usual
        coreDataStack = CoreDataStack(modelName: "TaskModel")
        
        // Overwrite the persistent store with an in-memory store in the managedContext
        let container = coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores.first
        if let storeCoordinator = coreDataStack.managedContext.persistentStoreCoordinator {
            do {
                try storeCoordinator.remove(container!)
                try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            } catch {
                XCTFail("Failed to set up in-memory store for testing: \(error.localizedDescription)")
            }
        }
    }
    
    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }
    
    func testManagedContext_NotNil() {
        XCTAssertNotNil(coreDataStack.managedContext, "The managed context should not be nil")
    }
    
    func testSaveContext_WithChanges() {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: coreDataStack.managedContext)!
        let newTask = NSManagedObject(entity: entity, insertInto: coreDataStack.managedContext)
        newTask.setValue("Test Task", forKey: "name")
        
        XCTAssertTrue(coreDataStack.managedContext.hasChanges, "The context should have changes after inserting a new task")
        
        coreDataStack.saveContext()
        
        XCTAssertFalse(coreDataStack.managedContext.hasChanges, "The context should not have changes after saving")
    }
    
    func testSaveContext_NoChanges() {
        coreDataStack.saveContext()
        XCTAssertFalse(coreDataStack.managedContext.hasChanges, "The context should not have changes without any modifications")
    }
    
    func testFetchRequest() {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: coreDataStack.managedContext)!
        let newTask = NSManagedObject(entity: entity, insertInto: coreDataStack.managedContext)
        newTask.setValue("Test Task", forKey: "name")
        
        coreDataStack.saveContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "name == %@", "Test Task")
        
        do {
            let fetchedTasks = try coreDataStack.managedContext.fetch(fetchRequest) as! [NSManagedObject]
            XCTAssertEqual(fetchedTasks.count, 1, "There should be one task in the context")
            XCTAssertEqual(fetchedTasks.first?.value(forKey: "name") as? String, "Test Task", "The task's name should match")
        } catch {
            XCTFail("Fetching tasks failed: \(error.localizedDescription)")
        }
    }
}
