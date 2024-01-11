//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Ramilia on 23/12/23.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    var viewModel = CategoriesViewModel()
    
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont(name: FontsString.sfProMedium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CategoryTableCell.self,
            forCellReuseIdentifier: CategoryTableCell.reuseIdentifier)
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont(name: FontsString.sfProMedium, size: 16)
        button.setTitleColor(.ypWhite1, for: .normal)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stub_zero_trackers") ?? UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\n объединить по смыслу"
        label.numberOfLines = 2
        label.font = UIFont(name: FontsString.sfProMedium, size: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        showStub()
    }
    
    @IBAction private func didTapDoneButton() {
        showCategoryViewController(isNew: true, categoryTitle: "")
    }
    
    private func showCategoryViewController(isNew: Bool, categoryTitle: String) {
        let categoryVC = CategoryActionViewController()
        categoryVC.setTitle(isNew: isNew, categoryTitle)
        categoryVC.delegate = self
        present(categoryVC, animated: true)
    }
    
    private func showStub() {
        let isEmpty = viewModel.categories.isEmpty
        categoriesTableView.isHidden = isEmpty
        stubImageView.isHidden = !isEmpty
        stubLabel.isHidden =  !isEmpty
    }
    
    private func addViews() {
        
        view.backgroundColor = .ypWhite1
        view.addSubview(headLabel)
        view.addSubview(categoriesTableView)
        view.addSubview(doneButton)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesTableView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 24),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor)
        ])
    }
}

extension CategoriesViewController: CategoryActionDelegate {
    
    func createCategory(categoryTitle: String) {
        viewModel.addCategory(categoryTitle)
        reloadData()
    }
    
    func updateCategory(oldTitle: String, newTitle: String) {
        viewModel.updateCategory(oldTitle: oldTitle, newTitle: newTitle)
        reloadData()
    }
    
    func reloadData() {
        categoriesTableView.reloadData()
        showStub()
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableCell.reuseIdentifier,
            for: indexPath) as? CategoryTableCell
        else {
            return UITableViewCell()
        }
        
        let category = viewModel.categories[indexPath.row]
        cell.updateTitle(title: category.title)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
            cell.layer.masksToBounds = false
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row != viewModel.categories.count - 1 {
            let separatorInset: CGFloat = 16
            let separatorWidth = tableView.bounds.width - separatorInset * 2
            let separatorHeight: CGFloat = 0.5
            let separatorX = separatorInset
            let separatorY = cell.frame.height - separatorHeight
            let separatorView = UIView(frame: CGRect(x: separatorX, y: separatorY, width: separatorWidth, height: separatorHeight))
            separatorView.backgroundColor = .ypGray1
            cell.addSubview(separatorView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableCell {
            cell.select()
            viewModel.selectCategory(index: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let category = viewModel.categories[indexPath.row]
        
        let editButton = UIAction(title: "Редактировать") { [weak self] _ in
            self?.showCategoryViewController(isNew: false, categoryTitle: category.title)
        }
        
        let deleteButton = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            let alert = UIAlertController(title: nil, message: "Эта категория точно не нужна?", preferredStyle: .actionSheet)
            
            let deleteButton = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.viewModel.deleteCategory(category.title)
                self.reloadData()
            }
            alert.addAction(deleteButton)
            
            let cancelButton = UIAlertAction(title: "Отмeнить", style: .cancel)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true)
        }
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [editButton, deleteButton])
        })
    }
}
