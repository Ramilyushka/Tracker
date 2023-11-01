//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Рамиля on 01/11/23.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var stubLabel: UILabel!
    @IBOutlet private weak var stubImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    @IBAction private func didTapPlusButton() {
        
    }
}

extension TrackersViewController {
    
    private func addViews(){
        addPlusButton()
        addHeadLabel()
        addStubImageView()
        addStubLabel()
    }
    
    private func addPlusButton() {
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        button.setImage( UIImage(named: "plus") ?? UIImage(), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
        
        plusButton = button
    }
    
    private func addHeadLabel() {
        
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        stubLabel = label
    }
    
    private func addStubImageView() {
        
        let image = UIImage(named: "stub_trackers") ?? UIImage()
        
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        stubImageView = imageView
    }
    
    private func addStubLabel() {
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8).isActive = true
        label.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor).isActive = true
        
        stubLabel = label
    }
}
