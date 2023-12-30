//
//  PageOnboardingViewController.swift
//  Tracker
//
//  Created by Ramilia on 23/12/23.
//

import UIKit

final class PageOnboardingViewController: UIViewController {
    
    private var pageNumber: Int = 1
    private var textLabel: String = ""
    
    private lazy var backGroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onboarding_page" + String(pageNumber)) ?? UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = textLabel
        label.font = UIFont(name: FontsString.sfProBold, size: 32)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont(name: FontsString.sfProMedium, size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(pageNumber: Int, textLabel: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.pageNumber = pageNumber
        self.textLabel = textLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
    }
    
    @IBAction private func didTapContinueButton() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func addViews() {
        view.addSubview(backGroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 432),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 160),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
