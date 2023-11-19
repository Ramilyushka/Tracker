//
//  TrackerRecordCellView.swift
//  Tracker
//
//  Created by Ramilia on 12/11/23.
//

import UIKit

final class TrackerRecordViewCell: UICollectionViewCell {
    static let reuseIdentifier = "cell"
    
    var subView = UIView()
    let nameTrackerLabel = UILabel()
    let emojiImageView = UILabel()
    let daysLabel = UILabel()
    var addButton = UIButton()
    var isDone = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTrackerData(tracker: Tracker) {
        subView.backgroundColor = tracker.color
        addButton.backgroundColor = tracker.color
        nameTrackerLabel.text = tracker.name
        emojiImageView.text = tracker.emoji
        daysLabel.text = "1 day"
    }
    
    @IBAction private func didTapPlusButton() {
        isDone.toggle()
        addButton.setImage(UIImage(named: isDone ? "done_tracker" : "add_tracker"), for: .normal)
    }
}

extension TrackerRecordViewCell {
    
    private func setupViewCell() {
        setupSubView()
        setupEmojiImageView()
        setupNameTrackerLabel()
        setupDaysLabel()
        setupAddButton()
    }
    
    private func setupDaysLabel() {
        
        daysLabel.font =  UIFont.systemFont(ofSize: 12, weight: .medium)
        
        contentView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: subView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupAddButton() {
        addButton = UIButton(type: .custom)
        addButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        addButton.setImage( UIImage(named: "add_tracker") ?? UIImage(), for: .normal)
        addButton.backgroundColor = .black
        
        addButton.layer.cornerRadius = 17
        addButton.layer.masksToBounds = true
        
        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.topAnchor.constraint(equalTo: subView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupSubView() {
        
        subView.layer.cornerRadius = 16
        subView.layer.masksToBounds = true
        
        contentView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            subView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            subView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            subView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupNameTrackerLabel() {
        
        nameTrackerLabel.lineBreakMode = .byWordWrapping
        nameTrackerLabel.numberOfLines = 0
        nameTrackerLabel.textColor = .white
        nameTrackerLabel.font =  UIFont.systemFont(ofSize: 12, weight: .medium)
        
        subView.addSubview(nameTrackerLabel)
        nameTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTrackerLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 12),
            nameTrackerLabel.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 12),
            nameTrackerLabel.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupEmojiImageView() {
        subView.addSubview(emojiImageView)
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiImageView.topAnchor.constraint(equalTo: subView.topAnchor, constant: 12),
            emojiImageView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 12),
            emojiImageView.heightAnchor.constraint(equalToConstant: 24),
            emojiImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
