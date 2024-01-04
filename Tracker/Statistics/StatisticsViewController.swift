//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Ramilia on 01/11/23.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let viewModel = StatisticsViewModel()
    
    private let titles: [String] = [
        "Лучший период", "Идеальные дни", "Трекеров завершено", "Среднее значение"
    ]
    
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics", comment: "")
        label.textColor = .ypBlack1
        label.font = UIFont(name: FontsString.sfProBold, size: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.rowHeight = 90
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        tableView.register(
            StattisticTableCell.self,
            forCellReuseIdentifier: StattisticTableCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stub_zero_statistics") ?? UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
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
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        showStub()
    }
    
    private func addViews() {
        
        view.backgroundColor = .ypWhite1
        view.addSubview(headLabel)
        view.addSubview(tableView)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 77),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 500),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor)
        ])
    }
    
    private func showStub() {
        let isEmpty = viewModel.trackers.isEmpty
        tableView.isHidden = isEmpty
        stubImageView.isHidden = !isEmpty
        stubLabel.isHidden =  !isEmpty
    }
}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StattisticTableCell.reuseIdentifier, for: indexPath) as? StattisticTableCell
        else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.updateTitle(title: title)
        
        var count = 0
        
        switch indexPath.row {
        case 0:
            count = 0
        case 1:
            count = 0
        case 2:
            count = viewModel.countAllCompletedTrackers ?? 0
        case 3:
            count = 0
        default:
            break
        }
        
        cell.updateCount(count: count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
}
