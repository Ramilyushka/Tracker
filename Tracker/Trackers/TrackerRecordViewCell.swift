
//
//  TrackerRecordCellView.swift
//  Tracker
//
//  Created by Ramilia on 12/11/23.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func incompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerRecordViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "cell"
    weak var delegate: TrackerCellDelegate?
    private var isCompleted = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    
    private var subView = UIView()
    private let nameTrackerLabel = UILabel()
    private let emojiLabel = UILabel()
    private var daysLabel = UILabel()
    private var addButton = UIButton()
    private let plusImage = UIImage(systemName: "plus") ?? UIImage()
    private let doneImage = UIImage(named: "done_tracker") ?? UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTrackerData(
        tracker: Tracker,
        selectedDate: Date,
        isCompleted: Bool,
        completedDays: Int,
        indexPath: IndexPath)
    {
        trackerID = tracker.id
        self.indexPath = indexPath
        
        subView.backgroundColor = tracker.color
        nameTrackerLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        
        self.isCompleted = isCompleted
        addButton.backgroundColor = tracker.color
        if selectedDate > Date() {
            addButton.isEnabled = false
            addButton.setImage(plusImage, for: .normal)
        } else {
            addButton.isEnabled = true
            addButton.setImage(isCompleted ? doneImage: plusImage, for: .normal)
        }
        
        daysLabel.text = completedDays.description + " дней"
    }
    
    @IBAction private func didTapPlusButton() {
        guard
            let id = trackerID,
            let index = indexPath
        else {
            assertionFailure("not found tracker ID or indexPath")
            return
        }
        if isCompleted {
            delegate?.incompleteTracker(id: id, at: index)
          }
        else {
            delegate?.completeTracker(id: id, at: index)
        }
    }
}

extension TrackerRecordViewCell {
    
    private func addViewCell() {
        addSubView()
        addEmojiImageView()
        addNameTrackerLabel()
        addDaysLabel()
        addAddButton()
    }
    
    private func addDaysLabel() {
        
        daysLabel.font = UIFont(name: ypFontMedium, size: 12)
        
        contentView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: subView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func addAddButton() {
        addButton = UIButton(type: .custom)
        addButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        addButton.setImage(plusImage, for: .normal)
        addButton.backgroundColor = .ypBlack1
        addButton.tintColor = .ypWhite1
        
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
    
    private func addSubView() {
        
        subView.layer.cornerRadius = 16
        subView.layer.masksToBounds = true
        
        contentView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subView.heightAnchor.constraint(equalToConstant: 90),
            subView.topAnchor.constraint(equalTo: contentView.topAnchor),
            subView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func addNameTrackerLabel() {
        
        nameTrackerLabel.lineBreakMode = .byWordWrapping
        nameTrackerLabel.numberOfLines = 0
        nameTrackerLabel.textColor = .white
        nameTrackerLabel.font =  UIFont(name: ypFontMedium, size: 12)
        
        subView.addSubview(nameTrackerLabel)
        nameTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTrackerLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 12),
            nameTrackerLabel.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 12),
            nameTrackerLabel.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -12)
        ])
    }
    
    private func addEmojiImageView() {
        emojiLabel.clipsToBounds = true
        emojiLabel.layer.cornerRadius = 26/2
        emojiLabel.backgroundColor = .ypLightGray
        emojiLabel.textAlignment = .center
        subView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: subView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 26),
            emojiLabel.widthAnchor.constraint(equalToConstant: 26)
        ])
    }
}
