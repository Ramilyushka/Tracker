//
//  CollectionViewHeader.swift
//  Tracker
//
//  Created by Ramilia on 15/12/23.
//

import UIKit

class HabitCollectionViewHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "headerView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack1
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
