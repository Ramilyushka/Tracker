//
//  CategoryTableCell.swift
//  Tracker
//
//  Created by Ramilia on 23/12/23.
//

import UIKit

final class CategoryTableCell: UITableViewCell {
    
    static let reuseIdentifier = "categoryCell"
    
    private var selectedCategory: Bool = false
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontsString.sfProRegular, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select_category") ?? UIImage()
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
        categoryLabel.text = title
    }
    
    func select() {
        selectedImageView.isHidden = false
    }
    
    func deselect() {
        selectedImageView.isHidden = true
    }
    
    private func addViews() {
        backgroundColor = .ypLightGray1
        clipsToBounds = true
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(selectedImageView)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectedImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
