//
//  FilterTableCell.swift
//  Tracker
//
//  Created by Ramilia on 04/01/24.
//

import UIKit

final class FilterTableCell: UITableViewCell {
    
    static let reuseIdentifier = "filterCell"
    
    private var selectedFilter: Bool = false
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontsString.sfProRegular, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select") ?? UIImage()
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    func updateTitle(title: String) {
        filterLabel.text = title
    }
    
    func select() {
        selectedImageView.isHidden = false
    }
    
    func deselect() {
        selectedImageView.isHidden = true
    }
    
    private func addViews() {
        backgroundColor = .ypBackground1
        
        contentView.addSubview(filterLabel)
        contentView.addSubview(selectedImageView)
        
        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            filterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectedImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
