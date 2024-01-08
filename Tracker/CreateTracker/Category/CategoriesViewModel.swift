//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Ramilia on 23/12/23.
//

import UIKit

final class CategoriesViewModel {
    
    @Observable
    private (set) var selectedCategory: String?
    
    private(set) var categories: [TrackerCategory] = []
    
    private let categoryStore = TrackerCategoryStore()

    init() {
        self.categoryStore.delegate = self
        self.categories = categoryStore.trackerCategories
    }

    func addCategory(_ title: String) {
        try? categoryStore.addEmptyCategory(with: title)
    }

    func updateCategory(oldTitle: String, newTitle: String) {
        try? categoryStore.updateTitle(oldTitle: oldTitle, newTitle: newTitle)
    }
    
    func deleteCategory(_ title: String) {
        try? categoryStore.remove(with: title)
    }
    
    func selectCategory(index: Int) {
        selectedCategory = categories[index].title
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func store() {
        categories = categoryStore.trackerCategories
    }
}
