//
//  TrackerCategoryViewHeader.swift
//  Tracker
//
//  Created by Ramilia on 12/11/23.
//

import UIKit

class TrackerCategoryViewHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "header"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel(){
        
        titleLabel.font =  UIFont.systemFont(ofSize: 19, weight: .bold)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
