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
    let pinned: Bool
    let schedule: [Schedule]
}
