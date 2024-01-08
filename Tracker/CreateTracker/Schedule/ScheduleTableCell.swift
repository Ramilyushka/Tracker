//
//  ScheduleTableCell.swift
//  Tracker
//
//  Created by Ramilia on 17/12/23.
//

import UIKit

final class ScheduleTableCell: UITableViewCell {
    
    static let reuseIdentifier = "scheduleCell"
    
    private var selectedDay: Bool = false
    
    private lazy var weekDayLabel: UILabel = {
        let dayOfWeek = UILabel()
        dayOfWeek.font = UIFont(name: FontsString.sfProRegular, size: 17)
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
    
    func isSelectedDay() -> Bool {
        return selectedDay
    }
    
    func setDay(index: Int) -> Schedule {
        if index == 6 {
            return .sunday
        } else {
            return Schedule(rawValue: index)!
        }
    }
    
    private func addViews() {
        backgroundColor = .ypBackground1
        
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
