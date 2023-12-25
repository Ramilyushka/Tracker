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
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.tintColor = .ypWhite1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont(name: FontsString.sfProMedium, size: 16)
        button.addTarget(self, action: #selector(didTapCreateCategoryButton), for: .touchUpInside)
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
    
    @IBAction private func didTapCreateCategoryButton() {
        let createNewCategoryVC = CategoryViewController()
        createNewCategoryVC.isNewCategory = true
        createNewCategoryVC.delegate = self
        present(createNewCategoryVC, animated: true)
    }
    
    private func addViews() {
        
        view.backgroundColor = .ypWhite1
        view.addSubview(headLabel)
        view.addSubview(categoriesTableView)
        view.addSubview(createCategoryButton)
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
            categoriesTableView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor, constant: -16),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor)
        ])
    }
    
    private func showStub() {
        let isEmpty = viewModel.categories.isEmpty
        categoriesTableView.isHidden = isEmpty
        stubImageView.isHidden = !isEmpty
        stubLabel.isHidden =  !isEmpty
    }
}

extension CategoriesViewController: CategoryActionDelegate {
    func createCategory(categoryTitle: String) {
        viewModel.addCategory(categoryTitle)
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
        if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
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
        guard indexPath.row < viewModel.categories.count else {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableCell {
            cell.select()
            viewModel.selectCategory(index: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
