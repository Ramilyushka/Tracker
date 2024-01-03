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
    case decodingErrorPinned
    case decodingErrorSchedule
    case decodingErrorInvalid
    case decodingErrorRecords
    case fetchError
    case removeError
}

protocol TrackerStoreDelegate: AnyObject {
    func storeTracker() -> Void
}

final class TrackerStore: NSObject {
    
    private let trackerRecordStore = TrackerRecordStore()
    //private let trackerCategoryStore = TrackerCategoryStore()
    
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
        guard let colorHex = trackerCoreData.color else {
            throw TrackerStoreError.decodingErrorColor
        }
        
        let pinned = trackerCoreData.pinned
        
        guard let scheduleArray = trackerCoreData.schedule as? [Int] else {
            throw TrackerStoreError.decodingErrorSchedule
        }
        
        let schedule = try scheduleArray.map {
            guard let weekDay = Schedule(rawValue: $0) else {
                throw TrackerStoreError.decodingErrorSchedule
            }
            return weekDay
        }
        
        return Tracker(id: id, title: title,
                       color: uiColorMarshalling.color(from: colorHex),
                       emoji: emoji,
                       pinned: pinned,
                       schedule: schedule)
    }
    
    func add(_ tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.pinned = tracker.pinned
        
        trackerCoreData.schedule = tracker.schedule.map { (item: Schedule) -> Int in
            return item.rawValue
        } as NSObject
        
        try context.save()
        return trackerCoreData
    }
    
    func update(categoryTitle: String, _ tracker: Tracker) throws {
        guard
            let trackerCoreData = try fetch(with: tracker.id)
        else {
            throw TrackerStoreError.fetchError
        }
        
        trackerCoreData.title = tracker.title
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule.map { (item: Schedule) -> Int in
            return item.rawValue
        } as NSObject
        
        let categoryFetch = TrackerCategoryStore()
        let category = try? categoryFetch.fetch(with: categoryTitle)
        
        trackerCoreData.category = category
        
        try context.save()
    }
    
    func remove(id: UUID?) throws {
        guard
            let trackerCoreData = try fetch(with: id)
        else {
            throw TrackerStoreError.fetchError
        }
        
        guard
            let _ = try? trackerRecordStore.removeByTrackerID(id) else {
            throw TrackerRecordStoreError.removeError
        }
        
        context.delete(trackerCoreData)
        try context.save()
    }
    
    func pin(_ tracker: Tracker?, value: Bool) throws {
        guard 
            let trackerCoreData = try fetch(with: tracker?.id)
        else {
            throw TrackerStoreError.fetchError
        }
        trackerCoreData.pinned = value
        try context.save()
    }
    
    private func fetch(with id: UUID?) throws -> TrackerCoreData? {
        
        guard let id = id else {
            return nil
        }
        
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        
        let result = try context.fetch(fetchRequest)
        return result.first
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeTracker()
    }
}
