//
//  TrackerModels.swift
//  Tracker
//
//  Created by Ramilia on 03/11/23.
//

import UIKit

//сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»)
struct Tracker {
    let id: UInt
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
}

struct Schedule {
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    let sunday: Bool
}

struct TrackerCategory{
    let name: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let id: UInt
    let date: Date
}
