//
//  AddNewTaskViewController.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import Foundation

class AddOrEditTaskViewController: NiblessViewController {
    let viewModel: AddOrEditTaskViewModel
    
    init(viewModel: AddOrEditTaskViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = AddOrEditTaskRootView(viewModel: viewModel)
    }
}
