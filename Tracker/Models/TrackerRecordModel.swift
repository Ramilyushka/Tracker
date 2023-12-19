//
//  TrackerRecordModel.swift
//  Tracker
//
//  Created by Ramilia on 19/12/23.
//

import Foundation

//сущность для хранения записи о том, что некий трекер был выполнен на некоторую дату;
struct TrackerRecord {
    let id: UUID
    let date: Date
}
