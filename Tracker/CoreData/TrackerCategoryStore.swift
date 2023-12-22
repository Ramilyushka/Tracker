//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Ramilia on 20/12/23.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorTitle
    case decodingErrorTrackers
    case fetchError
    case coreDataError
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeTrackerCategory() -> Void
}

final class TrackerCategoryStore: NSObject {
    
    private let trackerStore = TrackerStore()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
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
    
    var trackerCategories: [TrackerCategory] {
        guard
            let controller = fetchedResultsController,
            let objects = controller.fetchedObjects,
            let trackerCategories = try? objects.map({ try self.trackerCategory(from: $0)})
        else { return [] }
        return trackerCategories
    }
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorTitle
        }
        
        guard let trackers = trackerCategoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {
            throw TrackerCategoryStoreError.decodingErrorTrackers
        }
        
        return TrackerCategory(
            title: title,
            trackers: trackerStore.trackers.filter { trackers.map {$0.id}.contains($0.id) })
    }
    
    func addEmptyTrackerCategory(with categoryTitle: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = categoryTitle
        trackerCategoryCoreData.trackers = NSSet(array: [])
        
        try context.save()
    }
    
    func addNewTrackerToCategory(for categoryTitle: String, tracker: Tracker) throws {
        
        let trackerCoreData = try trackerStore.addNewTracker(tracker)
        
        guard 
            let trackerCategoryCoreData = try? fetchTrackerCategory(with: categoryTitle)
        else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = categoryTitle
            newCategory.trackers = NSSet(array: [trackerCoreData])
            try context.save()
            return
        }
        
        guard 
            let trackers = trackerCategoryCoreData.trackers,
            var updateTrackerCoreData = trackers.allObjects as? [TrackerCoreData]
        else {
            throw TrackerCategoryStoreError.coreDataError
        }
        
        updateTrackerCoreData.append(trackerCoreData)
        trackerCategoryCoreData.trackers = NSSet(array: updateTrackerCoreData)
        
        try context.save()
    }
    
    private func fetchTrackerCategory(with titleCategory: String) throws -> TrackerCategoryCoreData? {
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "title == %@",
            titleCategory as CVarArg
        )
        
        let result = try context.fetch(fetchRequest)
        return result.first
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeTrackerCategory()
    }
}
