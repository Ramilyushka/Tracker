//
//  TrackerCategoryModel.swift
//  Tracker
//
//  Created by Ramilia on 19/12/23.
//

import Foundation

//сущность для хранения трекеров по категориям.
struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}
