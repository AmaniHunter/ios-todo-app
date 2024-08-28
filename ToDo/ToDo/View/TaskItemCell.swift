//
//  TaskItemCell.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit


class TaskItemCell: UITableViewCell {
    private var task: Task?
    weak var delegate: TaskItemCellDelegate?
    static let reuseIdentifier = "TaskItemCell"
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private var completedSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .secondarySystemBackground
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(completedSwitch)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: completedSwitch.leadingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            completedSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            completedSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func configure(with task: Task, delegate: TaskItemCellDelegate) {
        self.task = task
        self.delegate = delegate
        nameLabel.text = task.name
        descriptionLabel.text = task.itemDescription
        completedSwitch.isOn = task.isCompleted
        
        // Remove any existing target to prevent multiple triggers
        completedSwitch.removeTarget(nil, action: nil, for: .allEvents)
        
        // Rebind the switch toggle action
        completedSwitch.addTarget(self, action: #selector(toggleTaskCompletion), for: .valueChanged)
    }
    
    @objc private func toggleTaskCompletion() {
        guard let task = task else { return }
        delegate?.taskCompletionToggled(for: task)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
        completedSwitch.isOn = false
        completedSwitch.removeTarget(nil, action: nil, for: .allEvents)
        delegate = nil
    }

}

protocol TaskItemCellDelegate: AnyObject {
    func taskCompletionToggled(for task: Task)
}

