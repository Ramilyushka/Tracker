//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Ramilia on 23/12/23.
//

import UIKit

protocol CategoryActionDelegate: AnyObject {
    func createCategory(categoryTitle: String)
    func updateCategory(oldTitle: String, newTitle: String)
}

final class CategoryActionViewController: UIViewController {
    
    weak var delegate: CategoryActionDelegate?
    
    private var isNewCategory = true
    private var selectedTitle: String?
    private var oldTitle: String = ""
    
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = UIFont(name: FontsString.sfProMedium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .ypBackground1
        textField.font = UIFont(name: FontsString.sfProRegular, size: 17)
        textField.placeholder = "Введите название категории"
        textField.textColor = .ypBlack1
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        
        textField.clearButtonMode = .whileEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont(name: FontsString.sfProMedium, size: 16)
        button.setTitleColor(.ypWhite1, for: .normal)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        updateDoneButtonState()
    }
    
    func setTitle(isNew: Bool, _ title: String) {
        isNewCategory = isNew
        if !isNew {
            headLabel.text = "Редактирование категории"
            titleTextField.text = title
            oldTitle = title
        }
    }
    
    @IBAction private func didTapDoneButton() {
        guard let title = selectedTitle else { return }
        if isNewCategory {
            delegate?.createCategory(categoryTitle: title)
        } else {
            delegate?.updateCategory(oldTitle: oldTitle, newTitle: title)
        }
        dismiss(animated: true)
    }
    
    private func addViews() {
        
        view.backgroundColor = .ypWhite1
        view.addSubview(headLabel)
        view.addSubview(titleTextField)
        view.addSubview(doneButton)
        titleTextField.delegate = self
        
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextField.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 24),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateDoneButtonState() {
        let isTitleSelected = !(titleTextField.text?.isEmpty ?? true)
        doneButton.isEnabled = isTitleSelected
        doneButton.backgroundColor = isTitleSelected ? .ypBlack1 : .ypGray1
    }
}

//MARK: UITextFieldDelegate
extension CategoryActionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedTitle = titleTextField.text
        updateDoneButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
