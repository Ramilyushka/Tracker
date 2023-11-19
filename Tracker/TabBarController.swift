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
        view.backgroundColor = .white
        self.viewControllers = [createTrackersItem(),
                                createStatisticsItem()]
    }
    
    private func createTrackersItem() -> UIViewController {
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers"),
            selectedImage: nil)
        
//        let navigation = UINavigationController(rootViewController: trackersViewController)
//        navigation.modalPresentationStyle = .fullScreen
//        trackersViewController.present(navigation, animated: true)
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
