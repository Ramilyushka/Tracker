//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Ramilia on 23/12/23.
//

import UIKit

final class CategoriesViewModel {
    
    @Observable
    private (set) var selectedCategory: TrackerCategory?
    
    private(set) var categories: [TrackerCategory] = []
    
    private let categoryStore = TrackerCategoryStore()

    init() {
        self.categoryStore.delegate = self
        self.categories = categoryStore.trackerCategories
    }

    func addCategory(_ title: String) {
        try? categoryStore.addEmptyTrackerCategory(with: title)
    }

    func deleteCategory() {
        //try! emojiMixStore.deleteAll()
    }
    
    func selectCategory(index: Int) {
        selectedCategory = categories[index]
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func storeTrackerCategory() {
        categories = categoryStore.trackerCategories
    }
}
