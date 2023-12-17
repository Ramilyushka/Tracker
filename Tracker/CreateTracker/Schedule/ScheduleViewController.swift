//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Ramilia on 16/12/23.
//

import UIKit

protocol ScheduleSelectionDelegate: AnyObject {
    func saveSelectedSchedule(_ selectedSchedule: [Schedule])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleSelectionDelegate?
    
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    private var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ScheduleTableCell.self,
            forCellReuseIdentifier: ScheduleTableCell.reuseIdentifier)
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    @IBAction private func didTapDoneButton() {
        var selected: [Schedule] = []
        for (index, elem) in scheduleTableView.visibleCells.enumerated() {
            guard let cell = elem as? ScheduleTableCell else {
                return
            }
            if cell.selectedDay {
                selected.append(cell.setDay(index: index))
            }
        }
        delegate?.saveSelectedSchedule(selected)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleTableCell.reuseIdentifier,
            for: indexPath) as? ScheduleTableCell 
        else {
            return UITableViewCell()
        }
        
        let dayOfWeek = Schedule.allCases[indexPath.row]
        cell.update(title: "\(dayOfWeek.daysNames)")
        cell.selectionStyle = .none
        
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
}

extension ScheduleViewController {
    
    private func addViews() {
        view.backgroundColor = .ypWhite1
        addHeadLabel()
        addScheduleTableView()
        addDoneButton()
    }
    
    private func addHeadLabel() {
        
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont(name: ypFontMedium, size: 16)
        label.textColor = .ypBlack1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        headLabel = label
    }
    
    private func addScheduleTableView() {
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scheduleTableView)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 30),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525)
        ])
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    private func addDoneButton() {
        
        let button = UIButton(type: .custom)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite1, for: .normal)
        button.backgroundColor = .ypBlack1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: scheduleTableView.bottomAnchor, constant: 50),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        doneButton = button
    }
}
