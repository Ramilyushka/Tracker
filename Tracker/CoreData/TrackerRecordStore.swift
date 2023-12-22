//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ramilia on 20/12/23.
//

import UIKit
import CoreData

enum TrackerRecordStoreError: Error {
    case decodingErrorTrackerID
    case decodingErrorDate
    case fetchError
    case deleteError
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func storeTrackerRecord() -> Void
}

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.trackerID, ascending: true)
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
    
    var trackerRecords: [TrackerRecord] {
        guard
            let controller = fetchedResultsController,
            let objects = controller.fetchedObjects,
            let trackerRecords = try? objects.map({ try self.trackerRecord(from: $0)})
        else { return [] }
        return trackerRecords
    }
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard  let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorTrackerID
        }
        guard let trackerId = trackerRecordCoreData.trackerID else {
            throw TrackerRecordStoreError.decodingErrorDate
        }
        
        return TrackerRecord(trackerID: trackerId, date: date)
    }
    
    func addTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerID = trackerRecord.trackerID
        trackerRecordCoreData.date = trackerRecord.date
        
        try context.save()
    }
    
    func removeTrackerRecord(_ trackerRecord: TrackerRecord?) throws {
        guard 
            let trackerRecordCoreData = try self.fetchTrackerRecord(with: trackerRecord)
        else {
            throw TrackerRecordStoreError.fetchError
        }
        context.delete(trackerRecordCoreData)
        try context.save()
    }
    
    private func fetchTrackerRecord(with trackerRecord: TrackerRecord?) throws -> TrackerRecordCoreData? {
        
        guard let trackerRecord = trackerRecord else {
            return nil
        }
        
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: trackerRecord.date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        fetchRequest.predicate = NSPredicate(
            format: "trackerID == %@ AND date>=%@ AND date<%@",
            trackerRecord.trackerID as CVarArg,
            startDate as CVarArg,
            endDate as CVarArg
        )
        
        let result = try context.fetch(fetchRequest)
        return result.first
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeTrackerRecord()
    }
}
