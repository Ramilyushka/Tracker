//
//  TabBarController.swift
//  Tracker
//
//  Created by Наиль on 01/11/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.viewControllers = [createTrackersItem(),
                                createStatisticsItem()]
    }
    
    private func createTrackersItem() -> UIViewController {
        let trackersViewController = TrackersViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers"),
            selectedImage: nil)
        
        return trackersViewController
    }
    
    private func createStatisticsItem() -> UIViewController {
        let statisticsViewController = StatisticsViewController()
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statistics"),
            selectedImage: nil
        )
        
        return statisticsViewController
    }
}
