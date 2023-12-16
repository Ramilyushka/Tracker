//
//  HabitTrackerTableCell.swift
//  Tracker
//
//  Created by Ramilia on 11/12/23.
//

import UIKit

final class HabitTrackerTableCell: UITableViewCell {
    
    static let reuseIdentifier = "habitCell"
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let chevronImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(text: String) {
        titleLabel.text = text
    }
}

extension HabitTrackerTableCell {
    
    private func addViews() {
        backgroundColor = .ypLightGray1
        addTitleLabel()
        addSubTitleLabel()
        addChevronImage()
    }
    
    private func addTitleLabel() {
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .ypBlack1
//        titleLabel.numberOfLines = 2
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        
        //let height = ((subTitleLabel.text?.isEmpty) != nil) ? 0 : -10.0
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ])
        
    }
    
    private func addSubTitleLabel() {
        
        subTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subTitleLabel.textColor = .ypGray1
        //subTitleLabel.text = "Домашний уют"
        
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
