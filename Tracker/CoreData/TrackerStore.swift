//
//  TrackerCoredata.swift
//  Tracker
//
//  Created by Ramilia on 20/12/23.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorID
    case decodingErrorTitle
    case decodingErrorEmoji
    case decodingErrorColor
    case decodingErrorSchedule
    case decodingErrorInvalid
}

protocol TrackerStoreDelegate: AnyObject {
    func storeTracker() -> Void
}

final class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    weak var delegate: TrackerStoreDelegate?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try? controller.performFetch()
    }
    
    var trackers: [Tracker] {
        guard
            let controller = fetchedResultsController,
            let objects = controller.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0)})
        else { return [] }
        return trackers
    }
    
    func addNewTracker(_ tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        
        trackerCoreData.schedule = tracker.schedule.map { (item: Schedule) -> Int in
            return item.rawValue
        } as NSObject
        
        try context.save()
        return trackerCoreData
    }
    
    private func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorID
        }
        guard let title = trackerCoreData.title else {
            throw TrackerStoreError.decodingErrorTitle
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorEmoji
        }
        guard  let colorHex = trackerCoreData.color else {
            throw TrackerStoreError.decodingErrorColor
        }
        
        guard let scheduleArray = trackerCoreData.schedule as? [Int] else {
            throw TrackerStoreError.decodingErrorSchedule
        }
        
        let schedule = try scheduleArray.map {
            guard let weekDay = Schedule(rawValue: $0) else {
                throw TrackerStoreError.decodingErrorSchedule
            }
            return weekDay
        }
        
        return Tracker(id: id, title: title, color: uiColorMarshalling.color(from: colorHex), emoji: emoji, schedule: schedule)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeTracker()
    }
}
