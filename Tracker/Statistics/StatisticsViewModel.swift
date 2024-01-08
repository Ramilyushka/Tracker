//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Ramilia on 05/01/24.
//

import UIKit

final class StatisticsViewModel {
    
    private let trackerStore = TrackerStore()
    private let recordStore = TrackerRecordStore()
    
    private (set) var trackers: [Tracker] = []
    private (set) var countAllCompletedTrackers: Int?

    init() {
        self.trackerStore.delegate = self
        self.recordStore.delegate = self
        
        self.trackers = trackerStore.trackers
        self.countAllCompletedTrackers = recordStore.countAllTrackerRecords
    }
}

extension StatisticsViewModel: TrackerRecordStoreDelegate, TrackerStoreDelegate {
    func store() {
        trackers = trackerStore.trackers
        countAllCompletedTrackers = recordStore.countAllTrackerRecords
    }
}
