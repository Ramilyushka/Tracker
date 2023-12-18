//
//  ScheduleTableCell.swift
//  Tracker
//
//  Created by Ramilia on 17/12/23.
//

import UIKit

final class ScheduleTableCell: UITableViewCell {
    
    static let reuseIdentifier = "scheduleCell"
    
    var selectedDay: Bool = false
    
    private lazy var weekDayLabel: UILabel = {
        let dayOfWeek = UILabel()
        dayOfWeek.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dayOfWeek.translatesAutoresizingMaskIntoConstraints = false
        return dayOfWeek
    }()
    
    private lazy var switchDay: UISwitch = {
        let switchDay = UISwitch()
        switchDay.onTintColor = UIColor.ypBlue
        switchDay.translatesAutoresizingMaskIntoConstraints = false
        switchDay.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        return switchDay
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    @objc private func didTapSwitch(_ sender: UISwitch) {
        self.selectedDay = sender.isOn
    }
    
    func update(title: String) {
        weekDayLabel.text = title
    }
    
    func setDay(index: Int) -> Schedule {
        let day: Schedule
        if index == 6 {
            day = .sunday
        } else {
            day = Schedule(rawValue: index+1)!
        }
        return day
    }
    
    private func addViews() {
        backgroundColor = .ypLightGray1
        
        contentView.addSubview(weekDayLabel)
        contentView.addSubview(switchDay)
        
        NSLayoutConstraint.activate([
            weekDayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weekDayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchDay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchDay.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
