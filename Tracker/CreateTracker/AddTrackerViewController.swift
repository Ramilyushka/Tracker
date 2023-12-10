//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Наиль on 11/12/23.
//

import UIKit

final class AddTrackerViewController: UIViewController {
    
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var habitTrackerButton: UIButton!
    @IBOutlet private weak var irregularTrackerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    @IBAction private func didTapHabitButton() {
        
    }
    
    @IBAction private func didTapIrregularButton() {
        
    }
}

extension AddTrackerViewController {
    
    private func addViews() {
        view.backgroundColor = .ypWhite1
        addHeadLabel()
        addHabitTrackerButton()
        addIrregularTrackerButton()
    }
    
    private func addHeadLabel() {
        
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont(name: ypFontMedium, size: 16)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        headLabel = label
    }
    
    private func addHabitTrackerButton() {
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.tintColor = .ypWhite1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont(name: ypFontMedium, size: 16)
        
        button.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 300),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        habitTrackerButton = button
    }
    
    private func addIrregularTrackerButton() {
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.tintColor = .ypWhite1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.font = UIFont(name: ypFontMedium, size: 16)
        
        button.addTarget(self, action: #selector(didTapIrregularButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: habitTrackerButton.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        irregularTrackerButton = button
    }
}
