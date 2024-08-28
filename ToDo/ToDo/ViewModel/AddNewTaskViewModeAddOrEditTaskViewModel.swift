//
//  AddOrEditTaskViewModel.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import Foundation

class AddOrEditTaskViewModel: NSObject {
    private let coreDataStack: CoreDataStack
     var task: Task?
    weak var coordinator: TaskListCoordinator?

    init(coreDataStack: CoreDataStack,
         task: Task? = nil,  // Existing task if editing
         coordinator: TaskListCoordinator? = nil) {
        self.coreDataStack = coreDataStack
        self.task = task
        self.coordinator = coordinator
        super.init()
    }

    func saveTask(name: String, description: String? = nil) {
        let taskToSave = task ?? Task(context: coreDataStack.managedContext) // Create new or use existing
        taskToSave.id = taskToSave.id ?? UUID()
        taskToSave.name = name
        taskToSave.itemDescription = description
        
        // Set isCompleted only for new tasks
        if task == nil {
            taskToSave.isCompleted = false  // Assume false for new tasks
        }
        taskToSave.dateCreated = taskToSave.dateCreated ?? Date()  // Set only if nil

        coreDataStack.saveContext()
        coordinator?.navigateBackToRoot()
    }
}
