//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Ramilia on 14/12/23.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "emojiCell"
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontsString.sfProRegular, size: 32)
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
