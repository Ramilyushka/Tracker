//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ramilia on 01/11/23.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var trackers: [Tracker] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private var selectedDate: Int?
    
    private let params = GeometricParams(cellCount: 2,
                                         leftInset: 16,
                                         rightInset: 16,
                                         cellSpacing: 10)
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var searchTextField: UISearchTextField!
    @IBOutlet private weak var stubLabel: UILabel!
    @IBOutlet private weak var stubImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        mockData()
        filteredTrackers(date: Date(), text: "")
    }
    
    @IBAction private func didTapPlusButton() {
        
    }
    
    @IBAction  private func datePickerValueChanged() {
        filteredTrackers(date: datePicker.date, text: searchTextField.text)
        dismiss(animated: true)
    }
    
    private func filteredTrackers(date: Date, text: String?) {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition =  tracker.schedule?.contains { weekday in
                    weekday.intValue == filterWeekDay
                } == true
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(name: category.name, trackers: trackers)
        }
        
        collectionView.reloadData()
        showStubTrackers()
    }
    
    private func reloadData() {
        visibleCategories = categories
        collectionView.reloadData()
    }
    
    private func mockData(){
        
        let tracker1 = Tracker(
            id: UUID.init(),
            name: "Поливать растения",
            color: .green,
            emoji: "🌸",
            schedule: [Schedule.sunday, Schedule.monday, Schedule.wednesday, Schedule.friday])
        
        let tracker2 = Tracker(
            id: UUID.init(),
            name: "Кошка заслонила камеру на созвоне",
            color: .orange,
            emoji: "😻",
            schedule: [Schedule.sunday, Schedule.monday, Schedule.wednesday, Schedule.thursday, Schedule.friday])
        
        let tracker3 = Tracker(
            id: UUID.init(),
            name: "Бабушка прислала открытку в вотсапе",
            color: .red,
            emoji: "🌸",
            schedule: [Schedule.sunday, Schedule.friday, Schedule.saturday])
        
        let tracker4 = Tracker(
            id: UUID.init(),
            name: "Свидания в апреле",
            color: .systemBlue,
            emoji: "❤️",
            schedule: [Schedule.monday])
        
        let tracker5 = Tracker(
            id: UUID.init(),
            name: "Хорошее настроение",
            color: .purple,
            emoji: "🙂",
            schedule: [Schedule.monday, Schedule.wednesday, Schedule.thursday, Schedule.friday])
        
        let tracker6 = Tracker(
            id: UUID.init(),
            name: "Легкая тревожность",
            color: .blue,
            emoji: "😪",
            schedule: [Schedule.wednesday, Schedule.thursday, Schedule.friday])
        
        trackers = [tracker1, tracker2, tracker3, tracker4, tracker5, tracker6]
        
        let category1 = TrackerCategory(name: "Домашний уют", trackers: [tracker1])
        let category2 = TrackerCategory(name: "Радостные мелочи", trackers: [tracker2, tracker3, tracker4])
        let category3 = TrackerCategory(name: "Самочувствие", trackers: [tracker5, tracker6])
        
        categories = [category1, category2, category3]
        
        visibleCategories = categories
        
        completedTrackers = [
            TrackerRecord(id: tracker1.id, date: Date()),
            TrackerRecord(id: tracker3.id, date: Date())
        ]
    }
}

extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filteredTrackers(date: datePicker.date, text: searchTextField.text)
    }
    
    func textFieldShouldReturn(_textField: UITextField) -> Bool {
        return true
    }
}

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
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        
        cell.setTrackerData(tracker: tracker, isCompleted: isCompleted, completedDays: completedDays, indexPath: indexPath)
        
        return cell
    }
    
    private func isTrackerCompleted (id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            
            return trackerRecord.id == id && isSameDay
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
            header.titleLabel.text = visibleCategories[indexPath.section].name
        }
        return header
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func incompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            
            return trackerRecord.id == id && isSameDay
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    //вертикальные отступы между ячейками внутри коллекции.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //горизонтальные отступы между ячейками.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    //задать отступы от краёв коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
    
    //---Для управления расположением и размерами элементов (включая размеры хедера)
    //---получает на вход объект коллекции, layout и номер секции, а возвращает её (секции) размер
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
}

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
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 7),
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
    }
    
    private func addDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
//        datePicker.backgroundColor = .ypBlue1
//        datePicker.tintColor = .ypWhite1
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        self.datePicker = datePicker
    }
    
    private func addHeadLabel() {
        
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont(name: ypFontBold, size: 34)
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
        label.text = "Добавьте первый трекер"
        label.font = UIFont(name: ypFontMedium, size: 12)
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
            stubLabel.text = isZeroTrackers ? "Добавьте первый трекер" : "Ничего не найдено"
        } else {
            collectionView.isHidden = false
            stubImageView.isHidden = true
            stubLabel.isHidden = true
        }
    }
}
