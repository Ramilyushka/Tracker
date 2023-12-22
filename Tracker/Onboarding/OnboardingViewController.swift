//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Ramilia on 22/12/23.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var pages: [UIViewController] = {
        let page1 = createPageViewController(title: "Отслеживайте только то, что хотите", pageCount: 1)
        
        let page2 = createPageViewController(title: "Даже если это не литры воды и йога", pageCount: 2)
        
        return [page1, page2]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack1
        pageControl.pageIndicatorTintColor = .ypGray1
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlack1
        button.tintColor = .ypWhite1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont(name: FontsString.sfProMedium, size: 16)
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        addViews()
    }
    
    @IBAction private func didTapContinueButton() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func addViews() {
        view.addSubview(pageControl)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 638),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createPageViewController(title: String, pageCount: Int) -> UIViewController {
        let page = UIViewController()
        
        let backGroundImageView = UIImageView()
        backGroundImageView.image = UIImage(named: "onboarding_page" + String(pageCount)) ?? UIImage()
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        page.view.addSubview(backGroundImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: FontsString.sfProBold, size: 32)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        backGroundImageView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: page.view.topAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: page.view.leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: page.view.trailingAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: page.view.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: backGroundImageView.topAnchor, constant: 432),
            titleLabel.leadingAnchor.constraint(equalTo: backGroundImageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backGroundImageView.trailingAnchor, constant: -16)
        ])
        
        return page
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
