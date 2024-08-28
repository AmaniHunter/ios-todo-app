//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit

class TaskListViewController: NiblessViewController {
    let viewModel: TaskListViewModel
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
    }
    
    override func loadView() {
        view = TaskListRootView(viewModel: viewModel)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Tasks"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        viewModel.navigateToAddTask()
    }
}
