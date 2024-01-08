//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Ramilia on 04/01/24.
//

import UIKit

protocol FiltersActionDelegate: AnyObject {
    func filterChange(selectFilter: Filters)
}

final class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersActionDelegate?
    private var selectedFilters: Filters?
     
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.textColor = .ypBlack1
        label.font = UIFont(name: FontsString.sfProMedium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypBackground1
        tableView.isScrollEnabled = false
        
        tableView.register(
            FilterTableCell.self,
            forCellReuseIdentifier: FilterTableCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    private func addViews() {
        
        view.backgroundColor = .ypWhite1
        view.addSubview(headLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setSelectFilter(filter: Filters?) {
        guard let filter = filter else {
            selectedFilters = Filters.allCases[0]
            return
        }
        selectedFilters = filter
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Filters.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterTableCell.reuseIdentifier,
            for: indexPath) as? FilterTableCell
        else {
            return UITableViewCell()
        }
        
        let filter = Filters.allCases[indexPath.row]
        cell.updateTitle(title: filter.rawValue)
        if selectedFilters != nil && selectedFilters == filter {
            cell.select()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row != Filters.allCases.count - 1 {
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
        if let cell = tableView.cellForRow(at: indexPath) as? FilterTableCell {
           
            cell.select()
            let filter = Filters.allCases[indexPath.row]
            delegate?.filterChange(selectFilter: filter)
            
            tableView.deselectRow(at: indexPath, animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
