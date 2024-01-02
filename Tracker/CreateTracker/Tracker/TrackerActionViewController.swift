//
//  AddHabitTrackerViewController.swift
//  Tracker
//
//  Created by Ramilia on 11/12/23.
//

import UIKit

protocol TrackerActionDelegate: AnyObject {
    func createTracker(categoryTitle: String, newTracker: Tracker)
    func updateTracker(tracker: Tracker)
}

final class TrackerActionViewController: UIViewController {

    var isHabit: Bool = true
    
    weak var delegate: TrackerActionDelegate?
    
    private var selectedTitle: String?
    private var selectedCategory: String?
    private var selectedSchedule: [Schedule] = []
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    
    private var isNew = true
    private var oldTracker: Tracker?
    
    private let colorsArray: [UIColor] = [
        .ypRedColorSelection, .ypOrangeColorSelection, .ypBlueColorSelection,
        .ypPurpleColorSelection, .ypGreenColorSelection, .ypDarkPinkColorSelection,
        .ypLightOrangeColorSelection, .ypSkyColorSelection, .ypLightGreenColorSelection,
        .ypDarkBlueColorSelection, .ypLightRedColorSelection, .ypPinkColorSelection,
        .ypLightYellowColorSelection, .ypLightBlueColorSelection, .ypDarkPurpleColorSelection,
        .ypLilacColorSelection, .ypDarkLilacColorSelection, .ypDarkGreenColorSelection
    ]
    
    private let emojiArray: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
        label.font = UIFont(name: FontsString.sfProMedium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .ypBackground1
        textField.font = UIFont(name: FontsString.sfProRegular, size: 17)
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlack1
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        
        textField.clearButtonMode = .whileEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    private lazy var errorLimitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontsString.sfProRegular, size: 17)
        label.text = "Ограничение 38 символов"
        label.textColor = .ypRed
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8.0
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypGray1
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed1, for: .normal)
        button.titleLabel?.font = UIFont(name: FontsString.sfProMedium, size: 16)
        button.backgroundColor = .ypWhite1
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.ypRed1.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private var trackerTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            TrackerTableCell.self,
            forCellReuseIdentifier: TrackerTableCell.reuseIdentifier)
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier)
        
        collectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier)
        
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    @IBAction private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapCreateButton() {
        
        guard
            let category = selectedCategory,
            let title = selectedTitle,
            let color = selectedColor,
            let emoji = selectedEmoji,
            let id = oldTracker?.id
        else {
            return
        }
        
        let tracker = Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            pinned: false,
            schedule: selectedSchedule)
        
        if isNew {
            delegate?.createTracker(categoryTitle: category, newTracker: tracker)
        } else {
            delegate?.updateTracker(tracker: tracker)
        }
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func updateCreateButtonState() {
        let isTitleSelected = !(titleTextField.text?.isEmpty ?? true)
        let isCategorySelected = !(selectedCategory?.isEmpty ?? true)
        let isScheduleSelected  = isHabit ? !(selectedSchedule.isEmpty) : true
        let isEmojiSelected = (selectedEmoji != nil)
        let isColorSelected = (selectedColor != nil)
        
        if isTitleSelected && isCategorySelected  && isEmojiSelected && isColorSelected && isScheduleSelected {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack1
            createButton.setTitleColor(.ypWhite1, for: .normal)
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray1
            createButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func setTracker(isNew: Bool, tracker: Tracker, categoryTitle: String) {
        self.isNew = isNew
        if !isNew {
            oldTracker = tracker
            headLabel.text = "Редактирование привычки"
            createButton.setTitle("Сохранить", for: .normal)
            titleTextField.text = tracker.title
            selectedTitle = tracker.title
            selectedCategory = categoryTitle
            selectedEmoji = tracker.emoji
            selectedColor = tracker.color
            selectedSchedule = tracker.schedule
            updateCreateButtonState()
        }
    }
}

//MARK: ScheduleSelectionDelegate
extension TrackerActionViewController: ScheduleSelectionDelegate {
    func saveSelectedSchedule(_ selectedSchedule: [Schedule]) {
        self.selectedSchedule = selectedSchedule
        trackerTableView.reloadData()
        updateCreateButtonState()
    }
}

//MARK: UITextFieldDelegate
extension TrackerActionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedTitle = titleTextField.text
        updateCreateButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        errorLimitLabel.isHidden = (count <= 38)
        return count <= 38
    }
}

//MARK: TableViewDataSource & TableViewDelegate
extension TrackerActionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isHabit ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = trackerTableView.dequeueReusableCell(
                withIdentifier: TrackerTableCell.reuseIdentifier,
                for: indexPath) as? TrackerTableCell
        else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.updateCategory(title: "Категория", subTitle: selectedCategory)
        }
        if isHabit && indexPath.row == 1 {
            cell.updateSchedule(title: "Расписание", selectedSchedule: selectedSchedule)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
            let separatorInset: CGFloat = 16
            let separatorWidth = tableView.bounds.width - separatorInset * 2
            let separatorHeight: CGFloat = 0.5
            let separatorX = separatorInset
            let separatorY = cell.frame.height - separatorHeight
            let separatorView = UIView(frame: CGRect(x: separatorX, y: separatorY, width: separatorWidth, height: separatorHeight))
            separatorView.backgroundColor = .ypGray1
            cell.addSubview(separatorView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoriesVC = CategoriesViewController()
            categoriesVC.viewModel.$selectedCategory.bind { [weak self] categoryTitle in
                self?.selectedCategory = categoryTitle
                self?.trackerTableView.reloadData()
            }
            present(categoriesVC, animated: true, completion: nil)
        }
        if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            present(scheduleVC, animated: true, completion: nil)
        }
        trackerTableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension TrackerActionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojiArray.count
        } else if collectionView == colorCollectionView {
            return colorsArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier,
                for: indexPath) as? EmojiCollectionViewCell
            else { return UICollectionViewCell() }
            
            let index = indexPath.item % emojiArray.count
            cell.emojiLabel.text = emojiArray[index]
            
            if let emoji = self.selectedEmoji {
                if emojiArray[index] == emoji {
                    cell.backgroundColor = .ypLightGray1
                }
            }
            
            cell.layer.cornerRadius = 16
            return cell
            
        } else if collectionView == colorCollectionView {
            guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ColorCollectionViewCell
            else { return UICollectionViewCell() }
            
            let index = indexPath.item % colorsArray.count
            cell.colorView.backgroundColor = colorsArray[index]
            
            
            if let color = self.selectedColor {
                if compareColor(color, colorsArray[index])  {
                    cell.layer.borderWidth = 3
                    cell.layer.borderColor = cell.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
                }
            }
            
            cell.layer.cornerRadius = 8
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    private func compareColor(_ color1: UIColor, _ color2: UIColor) -> Bool {
        let marsh = UIColorMarshalling()
        let color1 = marsh.hexString(from: color1)
        let color2 = marsh.hexString(from: color2)
        return color1 == color2
    }
    
    func collectionView(_ collectionView:UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier,
            for: indexPath) as? TrackerCollectionViewHeader 
        else {
            return UICollectionReusableView()
        }
        
        if collectionView == emojiCollectionView {
            header.titleLabel.text = "Emoji"
            return header
        } else if collectionView == colorCollectionView {
            header.titleLabel.text = "Цвет"
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let collectionViewWidth = collectionView.bounds.width - 36
          let cellWidth = collectionViewWidth / 6
          return CGSize(width: cellWidth, height: cellWidth)
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 5
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 1
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

//MARK: UICollectionViewDelegate
extension TrackerActionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == emojiCollectionView {
            
            collectionView.visibleCells.forEach {
                $0.backgroundColor = .ypWhite1
            }
            
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.backgroundColor = .ypLightGray
            
            selectedEmoji = cell?.emojiLabel.text
            
        } else if collectionView == colorCollectionView {
            
            collectionView.visibleCells.forEach {
                $0.layer.borderWidth = 0
            }
            
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            
            selectedColor = cell?.colorView.backgroundColor
        }
        
        updateCreateButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == emojiCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.backgroundColor = .ypWhite1
            selectedEmoji = nil
            
        } else if collectionView == colorCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.layer.borderWidth = 0
            selectedColor = nil
        }
        updateCreateButtonState()
    }
}

//MARK: Layout
extension TrackerActionViewController {
    
    private func addViews() {
        
        view.backgroundColor = .ypWhite1
        
        view.addSubview(scrollView)
        
        [headLabel, titleTextField, errorLimitLabel, trackerTableView, emojiCollectionView, colorCollectionView, stackView].forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
     
        //addEmojiCollectionView()
        //addColorCollectionView()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            
            headLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            headLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 24),
            titleTextField.centerXAnchor.constraint(equalTo: headLabel.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            errorLimitLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            errorLimitLabel.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor),
            
            trackerTableView.topAnchor.constraint(equalTo: errorLimitLabel.bottomAnchor, constant: 24),
            trackerTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackerTableView.heightAnchor.constraint(equalToConstant: isHabit ? 150.0: 75.0),
            
            emojiCollectionView.topAnchor.constraint(equalTo: trackerTableView.bottomAnchor, constant: 32),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 0),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
        ])
        
        titleTextField.delegate = self
        trackerTableView.dataSource = self
        trackerTableView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.allowsMultipleSelection = false
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.allowsMultipleSelection = false
    }
    
    private func addEmojiCollectionView() {
        emojiCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier)
        
        emojiCollectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
    }
    
    private func addColorCollectionView() {
        colorCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier)
        
        colorCollectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        
        scrollView.addSubview(colorCollectionView)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
}
