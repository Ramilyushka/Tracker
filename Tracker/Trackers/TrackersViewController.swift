//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ramilia on 01/11/23.
//

import UIKit

final class TrackersViewController: UIViewController, TrackerStoreDelegate {
    
    private let analyticsService = AnalyticsService()
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var pinnedTrackers: [Tracker] = []
    
    private var currentDate = Date()
    private var selectedSearchText: String?
    
    private let params = GeometricParams(cellCount: 2,
                                         leftInset: 16,
                                         rightInset: 16,
                                         cellSpacing: 10)
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private weak var datePicker: UIDatePicker!
    
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var headLabel: UILabel!
    
    @IBOutlet private weak var searchTextField: UISearchTextField!
    @IBOutlet private weak var stubLabel: UILabel!
    @IBOutlet private weak var stubImageView: UIImageView!
    @IBOutlet private weak var filterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        
        trackerStore.delegate = self
        pinnedTrackers = trackerStore.trackers.filter{ $0.pinned }
        
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
        print(categories)
        
        if !categories.isEmpty {
            categories.insert(TrackerCategory(title: "Закрепленные", trackers: pinnedTrackers), at: 0)
        }
        
   
        
        trackerRecordStore.delegate = self
        completedTrackers = trackerRecordStore.trackerRecords
        
        visibleCategories = categories
        filteredTrackers(date: Date(), text: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.report("open", params: ["screen": "Main"])
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report("close", params: ["screen": "Main"])
    }
    
    @IBAction private func didTapPlusButton() {
        analyticsService.report("click", params: ["screen": "Main", "item": "add_track"])
        let chooseTypeTrackerVC = ChooseTypeTrackerViewController()
        chooseTypeTrackerVC.delegate = self
        present(chooseTypeTrackerVC, animated: true)
    }
    
    @IBAction  private func datePickerValueChanged() {
        filteredTrackers(date: datePicker.date, text: searchTextField.text)
        dismiss(animated: true)
    }
    
    @IBAction  private func didTapFilterButton() {
        analyticsService.report("click", params: ["screen": "Main", "item": "filter"])
        let filtersVC = FiltersViewController()
       // filtersVC.delegate = self
        present(filtersVC, animated: true)
    }
    
    private func filteredTrackers(date: Date, text: String?) {
        currentDate = date
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.title.lowercased().contains(filterText)
                let dateCondition =  tracker.schedule.contains { weekday in
                    weekday.intValue == filterWeekDay
                } == true
                let irregular = tracker.schedule.isEmpty //нерегулярное событие отображается всегда
                return textCondition && (dateCondition || irregular)
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        collectionView.reloadData()
        showStubTrackers()
    }
}

//MARK: Store Delegates
extension TrackersViewController: TrackerCategoryStoreDelegate, TrackerRecordStoreDelegate {
    
    func store() {
        completedTrackers = trackerRecordStore.trackerRecords
        categories = trackerCategoryStore.trackerCategories
        pinnedTrackers = trackerStore.trackers.filter{ $0.pinned }
        categories.insert(TrackerCategory(title: "Закрепленные", trackers: pinnedTrackers), at: 0)
        filteredTrackers(date: currentDate, text: selectedSearchText)
    }
}

//MARK: TrackerActionDelegate
extension TrackersViewController: TrackerActionDelegate {
    
    func createTracker(categoryTitle: String, newTracker: Tracker) {
        
        try? trackerCategoryStore.addNewTrackerToCategory(for: categoryTitle, tracker: newTracker)
    }
    
    func updateTracker(categoryTitle: String, tracker: Tracker) {
        
        try? trackerStore.update(categoryTitle: categoryTitle, tracker)
    }
}

//MARK: TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        
        let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        analyticsService.report("click", params: ["screen": "Main", "item": "track"])
        
        try? trackerRecordStore.add(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func incompleteTracker(id: UUID, at indexPath: IndexPath) {
        
        let trackerRecord = completedTrackers.first { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerID == id && isSameDay
        }
        
        try? self.trackerRecordStore.remove(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
}

//MARK: UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerRecordViewCell.reuseIdentifier,
                for: indexPath) as? TrackerRecordViewCell
        else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        let isCompleted = isTrackerCompleted(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.trackerID == tracker.id }.count
        
        cell.setTrackerData(tracker: tracker,
                            selectedDate: self.currentDate,
                            isCompleted: isCompleted,
                            completedDays: completedDays, 
                            isPinned: tracker.pinned,
                            indexPath: indexPath)
        
        return cell
    }
    
    private func isTrackerCompleted (id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            
            return trackerRecord.trackerID == id && isSameDay
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: TrackerCategoryViewHeader.reuseIdentifier,
                for: indexPath) as? TrackerCategoryViewHeader
        else {
            return UICollectionReusableView()
        }
        if visibleCategories[indexPath.section].trackers.count != 0 {
            header.titleLabel.text = visibleCategories[indexPath.section].title
        }
        return header
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let pinnedButton = UIAction(title: tracker.pinned ? "Открепить" : "Закрепить") { [weak self] _ in
            try? self?.trackerStore.pin(tracker, value: !tracker.pinned)
        }
        
        let editButton = UIAction(title: "Редактировать") { [weak self] _ in
            guard let self = self else { return }
            guard let categoryTitle = self.categories.last(where: { $0.trackers.contains { $0.id == tracker.id } })?.title else { return }
            let completedDays = self.completedTrackers.filter { $0.trackerID == tracker.id }.count
            analyticsService.report("click", params: ["screen": "Main", "item": "edit"])
            self.showTrackerViewController(isNew: false, tracker: tracker, categoryTitle: categoryTitle, completedDays: completedDays)
        }
        
        let deleteButton = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            analyticsService.report("click", params: ["screen": "Main", "item": "delete"])
            
            let alert = UIAlertController(title: nil, message: "Уверены что хотите удалить трекер?", preferredStyle: .actionSheet)
            
            let deleteButton = UIAlertAction(title: "Удалить", style: .destructive) {  [weak self] _ in
                try? self?.trackerStore.remove(id: tracker.id)
            }
            alert.addAction(deleteButton)
            
            let cancelButton = UIAlertAction(title: "Отмeнить", style: .cancel)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true)
        }
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            let menuView = TrackerRecordViewCell().createContexMenuView(tracker: tracker)
            return menuView
        }) { _ in
            let actions = [pinnedButton, editButton, deleteButton]
            return UIMenu(title: "", children: actions)
        }
        
        return configuration
    }
    
    private func showTrackerViewController(isNew: Bool, tracker: Tracker, categoryTitle: String, completedDays: Int) {
        let trackerVC = TrackerActionViewController()
        trackerVC.delegate = self
        trackerVC.isHabit = !tracker.schedule.isEmpty
        trackerVC.setTracker(isNew: isNew, tracker: tracker, categoryTitle: categoryTitle, completedDays: completedDays)
        present(trackerVC, animated: true)
    }
}

//MARK: UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedSearchText = searchTextField.text
        filteredTrackers(date: datePicker.date, text: searchTextField.text)
    }
    
    func textFieldShouldReturn(_textField: UITextField) -> Bool {
        return true
    }
}

//MARK: Layout
extension TrackersViewController {
    
    private func addViews(){
        addPlusButton()
        addDatePicker()
        addHeadLabel()
        addSearchTextField()
        searchTextField.delegate = self
        addStubImageView()
        addStubLabel()
        addCollectionView()
        addFilterButton()
    }
    
    private func addCollectionView(){
        collectionView.register(
            TrackerCategoryViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryViewHeader.reuseIdentifier)
        
        collectionView.register(
            TrackerRecordViewCell.self,
            forCellWithReuseIdentifier: TrackerRecordViewCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false //нужно выбирать лишь одну ячейку
        collectionView.backgroundColor = .ypWhite1
    }
    
    private func addPlusButton() {
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        button.setImage( UIImage(named: "add_tracker") ?? UIImage(), for: .normal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        plusButton = button
    }
    
    private func addDatePicker() {
        let picker = UIDatePicker()
        picker.tintColor = .ypBlack1
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale.current
        
        picker.calendar.firstWeekday = 2
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 8
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: picker)
        
        NSLayoutConstraint.activate([
            picker.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        datePicker = picker
    }
    
    private func addHeadLabel() {
        
        let label = UILabel()
        label.text = NSLocalizedString("trackers", comment: "")
        label.font = UIFont(name: FontsString.sfProBold, size: 34)
        label.textColor = .ypBlack1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        headLabel = label
    }
    
    private func addSearchTextField() {
        
        let search = UISearchTextField()
        search.placeholder = NSLocalizedString("search", comment: "")
        search.returnKeyType = .done
        
        search.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(search)
        
        NSLayoutConstraint.activate([
            search.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 7),
            search.heightAnchor.constraint(equalToConstant: 36),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        searchTextField = search
    }
    
    private func addFilterButton() {
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        button.setTitle(NSLocalizedString("filters", comment: ""), for: .normal)
        button.backgroundColor = .ypBlue1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 114)
        ])
        
        filterButton = button
    }
    
    
    private func addStubImageView() {
        
        let image = UIImage(named: "stub_zero_trackers") ?? UIImage()
        
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        stubImageView = imageView
    }
    
    private func addStubLabel() {
        
        let label = UILabel()
        label.text = NSLocalizedString("emptyTrackers", comment: "")
        label.font = UIFont(name: FontsString.sfProMedium, size: 12)
        label.textColor = .ypBlack1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor)
        ])
        
        stubLabel = label
    }
    
    private func showStubTrackers() {
        if visibleCategories.isEmpty {
            let isZeroTrackers = categories.isEmpty
            collectionView.isHidden = true
            stubImageView.isHidden = false
            stubImageView.image = UIImage(
                named: isZeroTrackers ? "stub_zero_trackers" : "stub_not_found_trackers") ?? UIImage()
            
            stubLabel.isHidden = false
            stubLabel.text = isZeroTrackers ? NSLocalizedString("emptyTrackers", comment: "") : NSLocalizedString("emptySearch", comment: "")
        } else {
            collectionView.isHidden = false
            stubImageView.isHidden = true
            stubLabel.isHidden = true
        }
    }
}
