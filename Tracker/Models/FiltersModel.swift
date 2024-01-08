//
//  Filters.swift
//  Tracker
//
//  Created by Ramilia on 04/01/24.
//

import Foundation

enum Filters: String, CaseIterable {
    case allTrackers = "Все трекеры"
    case todayTrackers = "Трекеры на сегодня"
    case completedTrackers =  "Завершенные"
    case unCompletedTrackers =  "Не завершенные"
}
