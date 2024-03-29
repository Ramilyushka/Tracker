//
//  TabBarController.swift
//  Tracker
//
//  Created by Ramilia on 01/11/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite1
        self.viewControllers = [createTrackersItem(),
                                createStatisticsItem()]
    }
    
    private func createTrackersItem() -> UIViewController {
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", comment: ""),
            image: UIImage(named: "trackers"),
            selectedImage: nil)
        
        return trackersViewController
    }
    
    private func createStatisticsItem() -> UIViewController {
        let statisticsViewController = StatisticsViewController()
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", comment: ""),
            image: UIImage(named: "statistics"),
            selectedImage: nil
        )
        
        return statisticsViewController
    }
}
