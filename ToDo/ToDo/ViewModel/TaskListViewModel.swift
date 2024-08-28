//
//  TaskListViewModel.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import Foundation
import CoreData
import Combine

class TaskListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    enum RootViewState {
        case loading
        case noToDos
        case populated
        case error
    }
    
    private let coreDataStack: CoreDataStack
    private let fetchedResultsController: NSFetchedResultsController<Task>
    private var cancellables = Set<AnyCancellable>()
    
    // Coordinator reference
    weak var coordinator: TaskListCoordinator?
    
    // Publishing the view state and tasks
    @Published var viewState: RootViewState = .loading
    @Published private(set) var tasks: [Task] = []
    
    init(coreDataStack: CoreDataStack,
         coordinator: TaskListCoordinator? = nil) {
        self.coreDataStack = coreDataStack
        self.coordinator = coordinator
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            tasks = fetchedResultsController.fetchedObjects ?? []
            updateViewState()  // Update state here after fetching
        } catch {
            print("Fetch failed: \(error)")
            viewState = .error
        }
    }

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let updatedTasks = controller.fetchedObjects as? [Task] else { return }
        tasks = updatedTasks
        updateViewState()
    }
    
    private func updateViewState() {
        viewState = tasks.isEmpty ? .noToDos : .populated
    }
    
    func toggleTaskCompletion(task: Task) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let taskToDelete = fetchedResultsController.object(at: indexPath)
        coreDataStack.managedContext.delete(taskToDelete)
        saveContext()
    }
    
    func navigateToAddTask() {
        coordinator?.presentTaskViewController()
    }
    
    func editTask(at index: Int) {
            let task = tasks[index]
        coordinator?.presentTaskViewController(task: task)
        }
    
    func saveContext() {
        do {
            try coreDataStack.managedContext.save()
            // After saving, re-perform the fetch to make sure the data is up-to-date
            try fetchedResultsController.performFetch()
            tasks = fetchedResultsController.fetchedObjects ?? []
            updateViewState()
        } catch {
            print("Error saving context: \(error)")
            viewState = .error
        }
    }
}
