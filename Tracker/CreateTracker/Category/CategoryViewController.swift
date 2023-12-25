//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Ramilia on 23/12/23.
//

import UIKit

protocol CategoryActionDelegate: AnyObject {
    func createCategory(categoryTitle: String)
    func reloadData()
}

final class CategoryViewController: UIViewController {
    
    var isNewCategory = true
    weak var delegate: CategoryActionDelegate?
    
    private var selectedTitle: String?
    
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text =  isNewCategory ? "Новая категория" : "Редактирование категории"
        label.font = UIFont(name: FontsString.sfProMedium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .ypLightGray1
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
    
    private lazy var doneCategoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.tintColor = .ypWhite1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont(name: FontsString.sfProMedium, size: 16)
        button.addTarget(self, action: #selector(didTapCreateCategoryButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        updateDoneButtonState()
    }
    
    @IBAction private func didTapCreateCategoryButton() {
        guard let title = selectedTitle else { return }
        delegate?.createCategory(categoryTitle: title)
        delegate?.reloadData()
        dismiss(animated: true)
    }
    
    private func addViews() {
        
        view.backgroundColor = .ypWhite1
        view.addSubview(headLabel)
        view.addSubview(titleCategoryTextField)
        view.addSubview(doneCategoryButton)
        titleCategoryTextField.delegate = self
        
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleCategoryTextField.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 24),
            titleCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            titleCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateDoneButtonState() {
        let isTitleSelected = !(titleCategoryTextField.text?.isEmpty ?? true)
        doneCategoryButton.isEnabled = isTitleSelected
        doneCategoryButton.backgroundColor = isTitleSelected ? .ypBlack1 : .ypGray1
    }
}

//MARK: UITextFieldDelegate
extension CategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedTitle = titleCategoryTextField.text
        updateDoneButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
