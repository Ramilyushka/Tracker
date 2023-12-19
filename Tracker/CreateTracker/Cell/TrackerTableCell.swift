//
//  HabitTrackerTableCell.swift
//  Tracker
//
//  Created by Ramilia on 11/12/23.
//

import UIKit

final class TrackerTableCell: UITableViewCell {
    
    static let reuseIdentifier = "habitCell"
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let chevronImage = UIImageView()
    
    private var titleLabelCenterYAnchorConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCategory(title: String, subTitle: String?) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        titleLabelCenterYAnchorConstraint.constant = subTitle != nil ? -11 : 0
    }
    
    func updateSchedule(title: String, selectedSchedule: [Schedule]?) {
        
        titleLabel.text = title
        
        titleLabelCenterYAnchorConstraint.constant = selectedSchedule != nil ? -11 : 0
        
        guard let schedule = selectedSchedule else {
            return
        }
        
        if !schedule.isEmpty {
            if schedule.count == 7 {
                subTitleLabel.text = "Каждый день"
            } else {
                subTitleLabel.text = schedule.map { $0.daysShortNames }.joined(separator: ", ")
            }
        }
    }
}

extension TrackerTableCell {
    
    private func addViews() {
        backgroundColor = .ypLightGray1
        addTitleLabel()
        addSubTitleLabel()
        addChevronImage()
    }
    
    private func addTitleLabel() {
        
        titleLabel.font = UIFont(name: FontsString.sfProRegular, size: 17)
        titleLabel.textColor = .ypBlack1
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)

        titleLabelCenterYAnchorConstraint = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            titleLabelCenterYAnchorConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
    }
    
    private func addSubTitleLabel() {
        
        subTitleLabel.font = UIFont(name: FontsString.sfProRegular, size: 17)
        subTitleLabel.textColor = .ypGray1
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    private func addChevronImage() {
        
        chevronImage.image = UIImage(named: "chevron") ?? UIImage()
        
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(chevronImage)
        
        NSLayoutConstraint.activate([
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.heightAnchor.constraint(equalToConstant: 24),
            chevronImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
