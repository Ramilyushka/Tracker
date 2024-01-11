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
    func store() -> Void
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
    
    func addEmptyCategory(with categoryTitle: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = categoryTitle
        trackerCategoryCoreData.trackers = NSSet(array: [])
        
        try context.save()
    }
    
    func addNewTrackerToCategory(for categoryTitle: String, tracker: Tracker) throws {
        
        let trackerCoreData = try trackerStore.add(tracker)
        
        guard 
            let trackerCategoryCoreData = try? fetch(with: categoryTitle)
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
            throw TrackerCategoryStoreError.decodingErrorTrackers
        }
        
        
        updateTrackerCoreData.append(trackerCoreData)
        trackerCategoryCoreData.trackers = NSSet(array: updateTrackerCoreData)
        
        try context.save()
    }
    
    func updateTitle(oldTitle: String, newTitle: String) throws {
        
        guard
            let trackerCategoryCoreData = try? fetch(with: oldTitle)
        else {
           throw TrackerCategoryStoreError.fetchError
        }
        
        trackerCategoryCoreData.title = newTitle
        
        try context.save()
    }
    
    func remove(with categoryTitle: String) throws {
        guard
            let trackerCategoryCoreData = try self.fetch(with: categoryTitle)
        else {
            throw TrackerCategoryStoreError.fetchError
        }
        
        guard 
            let trackers = trackerCategoryCoreData.trackers,
            let deleteTrackersCoreData = trackers.allObjects as? [TrackerCoreData]
        else {
            throw TrackerCategoryStoreError.decodingErrorTrackers
        }
        
        for tracker in deleteTrackersCoreData {
            guard let _ = try? trackerStore.remove(id: tracker.id) else {
                throw TrackerStoreError.removeError
            }
        }
        
        context.delete(trackerCategoryCoreData)
        try context.save()
    }
    
    func fetch(with categoryTitle: String) throws -> TrackerCategoryCoreData? {
        
        if categoryTitle == "Закрепленные" {
            return nil
        }
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "title == %@",
            categoryTitle as CVarArg
        )
        
        let result = try context.fetch(fetchRequest)
        return result.first
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store()
    }
}
