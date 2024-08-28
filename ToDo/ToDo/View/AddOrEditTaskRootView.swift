//
//  AddOrEditTaskRootView.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit

class AddOrEditTaskRootView: NiblessView {
    let viewModel: AddNewTaskViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let taskNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Task Name"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private let taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "task name here"
        textField.textAlignment = .center
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(frame: CGRect = .zero,
         viewModel: AddOrEditTaskViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupScrollView()
        setupConstraints()
        customizeAppearance()
        populateFieldsIfEditing()
    }
    
    private func setupScrollView() {
        scrollView.keyboardDismissMode = .onDrag
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupConstraints() {
        contentView.addSubview(taskNameLabel)
        contentView.addSubview(taskNameTextField)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            // Constraints for taskNameLabel
            taskNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            taskNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Constraints for taskNameTextField
            taskNameTextField.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 8),
            taskNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            taskNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Constraints for descriptionLabel
            descriptionLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Constraints for descriptionTextView
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24),
            // Constraints for saveButton
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)])
    }
    
    private func customizeAppearance() {
        // Customize scrollView background color
        scrollView.backgroundColor = UIColor.systemGroupedBackground
        
        // Task Name TextField customizations
        taskNameTextField.backgroundColor = UIColor.systemGray6
        taskNameTextField.layer.cornerRadius = 10
        taskNameTextField.layer.shadowColor = UIColor.black.cgColor
        taskNameTextField.layer.shadowOpacity = 0.1
        taskNameTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        taskNameTextField.layer.shadowRadius = 4
        
        // Description TextView customizations
        descriptionTextView.backgroundColor = UIColor.systemGray6
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.shadowColor = UIColor.black.cgColor
        descriptionTextView.layer.shadowOpacity = 0.1
        descriptionTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        descriptionTextView.layer.shadowRadius = 4
        descriptionTextView.textColor = .darkGray
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    // Configure the text field
    private func configureTextField() {
        taskNameTextField.delegate = self
        taskNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        updateSaveButtonState()  // Initial state update
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = !(taskNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        saveButton.isEnabled = shouldEnableSaveButton
        saveButton.backgroundColor = shouldEnableSaveButton ? UIColor.systemBlue : UIColor.systemGray
    }
    
    private func populateFieldsIfEditing() {
        if let existingTask = viewModel.task {
            taskNameTextField.text = existingTask.name
            descriptionTextView.text = existingTask.itemDescription
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let taskName = taskNameTextField.text, !taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Task name is required")
            return
        }
        viewModel.saveTask(name: taskName, description: descriptionTextView.text)
    }
}
extension AddOrEditTaskRootView: UITextFieldDelegate {
    
}
