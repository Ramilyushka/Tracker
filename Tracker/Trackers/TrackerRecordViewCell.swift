
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
    private var isPinned = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    
    private var trackerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleTrackerLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.font =  UIFont(name: FontsString.sfProMedium, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 26/2
        label.backgroundColor = .ypLightGray1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pinnedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = false
        imageView.contentMode = .center
        imageView.image = UIImage(named: "pin") ?? UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var daysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack1
        label.font = UIFont(name: FontsString.sfProMedium, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.tintColor = .ypWhite1
        
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
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
        isPinned: Bool,
        indexPath: IndexPath)
    {
        trackerID = tracker.id
        self.indexPath = indexPath
        
        trackerView.backgroundColor = tracker.color
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
        
        daysLabel.text = String.localizedStringWithFormat(NSLocalizedString("completedDays", comment: ""), completedDays)
        
        self.isPinned = isPinned
        pinnedImageView.isHidden = !isPinned
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
        addTrackerView(view: contentView)
        addEmojiLabel()
        addPinnedImageView()
        addTitleTrackerLabel()
        addDaysLabel()
        addAddButton()
    }
    
    private func addTrackerView(view: UIView) {
        
        contentView.addSubview(trackerView)
        
        NSLayoutConstraint.activate([
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func addEmojiLabel() {
        trackerView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 26),
            emojiLabel.widthAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    private func addTitleTrackerLabel() {
        
        trackerView.addSubview(titleTrackerLabel)
        
        NSLayoutConstraint.activate([
            titleTrackerLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            titleTrackerLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: 12),
            titleTrackerLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func addDaysLabel() {
        
        contentView.addSubview(daysLabel)
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func addPinnedImageView() {
        trackerView.addSubview(pinnedImageView)
        
        NSLayoutConstraint.activate([
            pinnedImageView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            pinnedImageView.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -4),
            pinnedImageView.heightAnchor.constraint(equalToConstant: 24),
            pinnedImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func addAddButton() {
        
        addButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension TrackerRecordViewCell {
    
    func createContexMenuView (size: CGSize, tracker: Tracker) -> UIViewController {
        let menuView = UIViewController()
        
        menuView.preferredContentSize = size
        
        menuView.view.backgroundColor = tracker.color
        
        menuView.view.addSubview(emojiLabel)
        menuView.view.addSubview(titleTrackerLabel)
        menuView.view.addSubview(pinnedImageView)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: menuView.view.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: menuView.view.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 26),
            emojiLabel.widthAnchor.constraint(equalToConstant: 26),
            titleTrackerLabel.leadingAnchor.constraint(equalTo: menuView.view.leadingAnchor, constant: 12),
            titleTrackerLabel.trailingAnchor.constraint(equalTo: menuView.view.trailingAnchor, constant: 12),
            titleTrackerLabel.bottomAnchor.constraint(equalTo: menuView.view.bottomAnchor, constant: -12),
            pinnedImageView.topAnchor.constraint(equalTo: menuView.view.topAnchor, constant: 12),
            pinnedImageView.trailingAnchor.constraint(equalTo: menuView.view.trailingAnchor, constant: -4),
            pinnedImageView.heightAnchor.constraint(equalToConstant: 24),
            pinnedImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        titleTrackerLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        pinnedImageView.isHidden = !tracker.pinned
        
        return menuView
    }
}
