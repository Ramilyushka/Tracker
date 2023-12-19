
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
    
    private var view = UIView()
    private let titleTrackerLabel = UILabel()
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
        
        view.backgroundColor = tracker.color
        titleTrackerLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        
        self.isCompleted = isCompleted
        addButton.backgroundColor = tracker.color
        
        if selectedDate > Date() {
            addButton.isEnabled = false
            addButton.setImage(plusImage, for: .normal)
            addButton.alpha = 0.3
        } else {
            addButton.isEnabled = true
            addButton.setImage(isCompleted ? doneImage: plusImage, for: .normal)
            addButton.alpha = isCompleted ? 0.3 : 1.0
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
        addView()
        addEmojiLabel()
        addTitleTrackerLabel()
        addDaysLabel()
        addAddButton()
    }
    
    private func addView() {
        
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 90),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func addEmojiLabel() {
        emojiLabel.clipsToBounds = true
        emojiLabel.layer.cornerRadius = 26/2
        emojiLabel.backgroundColor = .ypLightGray
        emojiLabel.textAlignment = .center
        view.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 26),
            emojiLabel.widthAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    private func addTitleTrackerLabel() {
        
        titleTrackerLabel.lineBreakMode = .byWordWrapping
        titleTrackerLabel.numberOfLines = 0
        titleTrackerLabel.textColor = .white
        titleTrackerLabel.font =  UIFont(name: FontsString.sfProMedium, size: 12)
        
        view.addSubview(titleTrackerLabel)
        titleTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTrackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleTrackerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12),
            titleTrackerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }
    
    private func addDaysLabel() {
        
        daysLabel.font = UIFont(name: FontsString.sfProMedium, size: 12)
        
        contentView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
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
            addButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
