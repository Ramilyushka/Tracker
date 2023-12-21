//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ramilia on 01/11/23.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
        
        trackerRecordStore.delegate = self
        completedTrackers = trackerRecordStore.trackerRecords
        
        visibleCategories = categories
        filteredTrackers(date: Date(), text: "")
    }
    
    @IBAction private func didTapPlusButton() {
        let chooseTypeTrackerVC = ChooseTypeTrackerViewController()
        chooseTypeTrackerVC.delegate = self
        present(chooseTypeTrackerVC, animated: true)
    }
    
    @IBAction  private func datePickerValueChanged() {
        filteredTrackers(date: datePicker.date, text: searchTextField.text)
        dismiss(animated: true)
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
    
    func storeTrackerCategory() {
        categories = trackerCategoryStore.trackerCategories
        filteredTrackers(date: currentDate, text: selectedSearchText)
    }
    
    func storeTrackerRecord() {
        completedTrackers = trackerRecordStore.trackerRecords
    }
}

//MARK: TrackerActionDelegate
extension TrackersViewController: TrackerActionDelegate {
    
    func createTracker(categoryTitle: String, title: String, color: UIColor, emoji: String, schedule: [Schedule]) {
        let newTracker = Tracker(
            id: UUID.init(),
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule)
        
        try? trackerCategoryStore.addNewTrackerToCategory(for: categoryTitle, tracker: newTracker)
    }
}

//MARK: TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        
        let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        try? trackerRecordStore.addTrackerRecord(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func incompleteTracker(id: UUID, at indexPath: IndexPath) {
        
        let trackerRecord = completedTrackers.first { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerID == id && isSameDay
        }
        
        try? self.trackerRecordStore.removeTrackerRecord(trackerRecord)
        
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
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_Ru")
        
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
        label.text = "Трекеры"
        label.font = UIFont(name: FontsString.sfProBold, size: 34)
        label.textColor = .black
        
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
        search.placeholder = "Поиск"
        search.backgroundColor = .ypLightGray1
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
        label.text = "Что будем отслеживать?"
        label.font = UIFont(name: FontsString.sfProMedium, size: 12)
        label.textColor = .black
        
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
            stubLabel.text = isZeroTrackers ? "Что будем отслеживать?" : "Ничего не найдено"
        } else {
            collectionView.isHidden = false
            stubImageView.isHidden = true
            stubLabel.isHidden = true
        }
    }
}
