//
//  TaskListCoordinator.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit

class TaskListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var coreDataStack: CoreDataStack

    init(navigationController: UINavigationController, coreDataStack: CoreDataStack) {
        self.navigationController = navigationController
        self.coreDataStack = coreDataStack
    }
    
    func start() {
        let viewModel = TaskListViewModel(coreDataStack: coreDataStack, coordinator: self)
        let taskListViewController = TaskListViewController(viewModel: viewModel)
        navigationController.pushViewController(taskListViewController, animated: true)
    }
    
    func presentTaskViewController(task: Task? = nil) {
        let taskViewModel = AddOrEditTaskViewModel(coreDataStack: coreDataStack, task: task, coordinator: self)
        let taskViewController = AddOrEditTaskViewController(viewModel: taskViewModel)
        navigationController.pushViewController(taskViewController, animated: true)
    }
    
    func navigateBackToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
