//
//  StattisticTableCell.swift
//  Tracker
//
//  Created by Ramilia on 04/01/24.
//

import UIKit

final class StattisticTableCell: UITableViewCell {
    
    static let reuseIdentifier = "statisticCell"
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontsString.sfProBold, size: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontsString.sfProMedium, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let borderView: UIView = {
        let borderView = UIView()
        borderView.layer.cornerRadius = 16
        borderView.backgroundColor = .ypBlue1
        borderView.translatesAutoresizingMaskIntoConstraints = false
        return borderView
    }()
      
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.ypRedColorSelection.cgColor, UIColor.ypLightGreenColorSelection.cgColor, UIColor.ypBlueColorSelection.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 16
        return gradientLayer
    }()
    
    private let subView: UIView = {
        let insideView = UIView()
        insideView.layer.cornerRadius = 16
        insideView.backgroundColor = .ypWhite1
        insideView.translatesAutoresizingMaskIntoConstraints = false
        return insideView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
   
    required init?(coder: NSCoder) {
        
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
         gradientLayer.frame = borderView.bounds
     }
    
    func updateTitle(title: String) {
        titleLabel.text = title
    }
    
    func updateCount(count: Int) {
        countLabel.text = String(count)
    }
    
    private func addViews() {
        backgroundColor = .clear
        clipsToBounds = true
        
        contentView.addSubview(borderView)
        contentView.addSubview(subView)
        contentView.addSubview(countLabel)
        contentView.addSubview(titleLabel)
        borderView.layer.addSublayer(gradientLayer)
        
        NSLayoutConstraint.activate([
            borderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            borderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 90),
            
            subView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 1),
            subView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -1),
            subView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 1),
            subView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -1),
            
            countLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            countLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}

