//
//  AddHabitTrackerViewController.swift
//  Tracker
//
//  Created by Ramilia on 11/12/23.
//

import UIKit

final class AddHabitTrackerViewController: UIViewController {
    
    private let colorsArray: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3,
        .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9,
        .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
        .ypColorSelection16, .ypColorSelection17, .ypColorSelection18
    ]
    
    private let emojiArray: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var titleTrackerTextField: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private var habitTrackerTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            HabitTrackerTableCell.self,
            forCellReuseIdentifier: HabitTrackerTableCell.reuseIdentifier)
        tableView.layer.cornerRadius = 16
        //tableView.separatorStyle = .none
        return tableView
    }()
    
    private var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    @IBAction private func didTapCancelButton() {
    }
    
    @IBAction private func didTapCreateButton() {
    }
}

extension AddHabitTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = habitTrackerTableView.dequeueReusableCell(
                withIdentifier: HabitTrackerTableCell.reuseIdentifier,
                for: indexPath) as? HabitTrackerTableCell
        else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.updateText(text: "Категория")
        }
        if indexPath.row == 1 {
            cell.updateText(text: "Расписание")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if indexPath.row == 0 {
    //            let separatorInset: CGFloat = 16
    //            let separatorWidth = tableView.bounds.width - separatorInset * 2
    //            let separatorHeight: CGFloat = 1.0
    //            //let separatorX = separatorInset
    //            let separatorY = cell.frame.height - separatorHeight
    //            let separatorView = UIView(frame: CGRect(x: separatorInset, y: separatorY, width: separatorWidth, height: separatorHeight))
    //            separatorView.backgroundColor = .ypGray
    //            cell.addSubview(separatorView)
    //        }
    //    }
}

extension AddHabitTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            return cell
            
        } else if collectionView == colorCollectionView {
            guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ColorCollectionViewCell
            else { return UICollectionViewCell() }
            
            let index = indexPath.item % colorsArray.count
            cell.colorView.backgroundColor = colorsArray[index]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView:UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HabitCollectionViewHeader.reuseIdentifier,
            for: indexPath) as? HabitCollectionViewHeader 
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
          // return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
          return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

extension AddHabitTrackerViewController {
    private func addViews() {
        view.backgroundColor = .ypWhite1
        addScrollView()
        addHeadLabel()
        addTitleTrackerTextField()
        addHabitTrackerTableView()
        addEmojiCollectionView()
        addColorCollectionView()
        addStackView()
        addCancelButton()
        addCreateButton()
    }
    
    private func addScrollView() {
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addHeadLabel() {
        
        let label = UILabel()
        label.text = "Создание привычки"
        label.font = UIFont(name: ypFontMedium, size: 16)
        label.textColor = .ypBlack1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        headLabel = label
    }
    
    private func addTitleTrackerTextField() {
        
        let textField = UITextField()
        textField.backgroundColor = .ypLightGray1
        textField.font = UIFont(name: ypFontMedium, size: 17)
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlack1
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.becomeFirstResponder()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 24),
            textField.centerXAnchor.constraint(equalTo: headLabel.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
        
        titleTrackerTextField = textField
    }
    
    private func addHabitTrackerTableView() {
        
        habitTrackerTableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(habitTrackerTableView)
        
        NSLayoutConstraint.activate([
            habitTrackerTableView.topAnchor.constraint(equalTo: titleTrackerTextField.bottomAnchor, constant: 24),
            habitTrackerTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            habitTrackerTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            habitTrackerTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        habitTrackerTableView.dataSource = self
        habitTrackerTableView.delegate = self
    }
    
    private func addEmojiCollectionView() {
        emojiCollectionView.register(
            HabitCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HabitCollectionViewHeader.reuseIdentifier)
        
        emojiCollectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        
        scrollView.addSubview(emojiCollectionView)
        
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: habitTrackerTableView.bottomAnchor, constant: 32),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.allowsMultipleSelection = false
    }
    
    private func addColorCollectionView() {
        colorCollectionView.register(
            HabitCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HabitCollectionViewHeader.reuseIdentifier)
        
        colorCollectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        
        scrollView.addSubview(colorCollectionView)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 0),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.allowsMultipleSelection = false
    }
    
    private func addStackView() {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8.0
        //stack.alignment = .center
        stack.distribution = .fillEqually
        
        scrollView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            stack.heightAnchor.constraint(equalToConstant: 60),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        stackView = stack
    }
    
    private func addCancelButton() {
        
        let button = UIButton(type: .custom)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed1, for: .normal)
        button.backgroundColor = .ypWhite1
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.ypRed1.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
        //scrollView.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            button.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
//            button.heightAnchor.constraint(equalToConstant: 60),
//            button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 19)
//        ])
        
        cancelButton = button
    }
    
    private func addCreateButton() {
        
        let button = UIButton(type: .custom)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite1, for: .normal)
        button.backgroundColor = .ypGray1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
//        scrollView.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            button.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
//            button.heightAnchor.constraint(equalToConstant: 60),
//            button.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: 8),
//            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
//        ])
        
        createButton = button
    }
}
