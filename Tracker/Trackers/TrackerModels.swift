//
//  TrackerModels.swift
//  Tracker
//
//  Created by Ramilia on 03/11/23.
//

import UIKit

//сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»)
struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Schedule]?
}
enum Schedule: Int, CaseIterable {
    
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var intValue: Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
    
    var daysNames: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    var daysShortNames: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вc"
        }
    }
}

//сущность для хранения трекеров по категориям.
struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
}

//сущность для хранения записи о том, что некий трекер был выполнен на некоторую дату;
struct TrackerRecord {
    let id: UUID
    let date: Date
}

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    // Параметр вычисляется уже при создании, что экономит время на вычислениях при отрисовке коллекции.
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
