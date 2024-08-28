//
//  TaskListRootView.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit
import Combine

class TaskListRootView: NiblessView {
    let viewModel: TaskListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TaskItemCell.self, forCellReuseIdentifier: "TaskItemCell")
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        return table
    }()
    
    private lazy var messageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true  // Initially hidden
        return stack
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(frame: CGRect = .zero,
         viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(messageStackView)
        messageStackView.addArrangedSubview(activityIndicator)
        messageStackView.addArrangedSubview(messageLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                
                self?.updateUI(for: state)
            })
            .store(in: &cancellables)
        
        viewModel.$tasks
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                // Whenever the tasks change, reload the table view
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    private func updateUI(for state: TaskListViewModel.RootViewState) {
        switch state {
        case .loading:
            tableView.isHidden = true
            messageStackView.isHidden = false
            messageLabel.text = "Loading..."
            activityIndicator.startAnimating()
        case .noToDos:
            tableView.isHidden = true
            messageStackView.isHidden = false
            messageLabel.text = "No tasks currently, create one :)"
            activityIndicator.stopAnimating()
        case .populated:
            tableView.isHidden = false
            messageStackView.isHidden = true
        case .error:
            tableView.isHidden = true
            messageStackView.isHidden = false
            messageLabel.text = "An error occurred while fetching tasks."
            activityIndicator.stopAnimating()
        }
    }
}

extension TaskListRootView: UITableViewDelegate, UITableViewDataSource, TaskItemCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.tasks.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskItemCell.reuseIdentifier, for: indexPath) as? TaskItemCell else {
             return UITableViewCell()  // Return an empty cell if casting fails
         }
         
         let task = viewModel.tasks[indexPath.row]
         cell.configure(with: task, delegate: self)
         
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            viewModel.editTask(at: indexPath.row)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.viewModel.deleteTask(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func taskCompletionToggled(for task: Task) {
            viewModel.toggleTaskCompletion(task: task)
        }

}
