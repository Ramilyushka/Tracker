//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ramilia on 01/11/23.
//

import UIKit

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    // Параметр вычисляется уже при создании, что экономит время на вычислениях при отрисовке коллекции.
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}

final class TrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var trackers: [Tracker] = []
    var completedTrackers: [TrackerRecord] = []
    var selectedDate = Date()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let params = GeometricParams(cellCount: 2,
                                 leftInset: 16,
                                 rightInset: 16,
                                 cellSpacing: 10)
    
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchTextField!
    @IBOutlet private weak var stubLabel: UILabel!
    @IBOutlet private weak var stubImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        mockData()
    }
    
    @IBAction private func didTapPlusButton() {
        
    }
    
    @IBAction  private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
//        let formattedDate = dateFormatter.string(from: selectedDate)
        //print("Выбранная дата: \(formattedDate)")
    }
    
    private func mockData(){
        let shedule = Schedule(monday: true, tuesday: false, wednesday: true, thursday: true, friday: false, saturday: false, sunday: false)
        let tracker1 = Tracker(id: 1, name: "Поливать растения", color: .green, emoji: "🌸", schedule: shedule)
        let tracker2 = Tracker(id: 2, name: "Кошка заслонила камеру на созвоне", color: .orange, emoji: "😻", schedule: shedule)
        let tracker3 = Tracker(id: 3, name: "Бабушка прислала открытку в вотсапе", color: .red, emoji: "🌸", schedule: shedule)
        let tracker4 = Tracker(id: 4, name: "Свидания в апреле", color: .systemBlue, emoji: "❤️", schedule: shedule)
        let tracker5 = Tracker(id: 5, name: "Хорошее настроение", color: .purple, emoji: "🙂", schedule: shedule)
        let tracker6 = Tracker(id: 6, name: "Легкая тревожность", color: .blue, emoji: "😪", schedule: shedule)
        
        trackers = [tracker1, tracker2, tracker3, tracker4, tracker5, tracker6]
        
        let category1 = TrackerCategory(name: "Домашний уют", trackers: [tracker1])
        let category2 = TrackerCategory(name: "Радостные мелочи", trackers: [tracker3, tracker2, tracker4])
        let category3 = TrackerCategory(name: "Самочувствие", trackers: [tracker5, tracker6])
        
        categories = [category1, category2, category3]
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard 
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerRecordViewCell.reuseIdentifier,
                for: indexPath) as? TrackerRecordViewCell
        else {
            return UICollectionViewCell()
        }
        
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        cell.setTrackerData(tracker: tracker)
        
        return cell
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
        header.titleLabel.text = categories[indexPath.section].name
        return header
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: cellWidth * 5 / 4)
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
        
//        let indexPath = IndexPath(row: 0, section: section)
//        let headerView = self.collectionView(
//            collectionView,
//            viewForSupplementaryElementOfKind:UICollectionView.elementKindSectionHeader,
//            at: indexPath)
        
//        return headerView.systemLayoutSizeFitting(
//            CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel)
        
        return CGSize(width: collectionView.frame.width, height: 20)
    }
}

extension TrackersViewController {
    
    private func addViews(){
        addPlusButton()
        addDatePicker()
        addHeadLabel()
        addSearchBar()
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
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 7),
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
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func addHeadLabel() {
        
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        headLabel = label
    }
    
    private func addSearchBar() {
        
        let search = UISearchTextField()
        search.placeholder = "Поиск"
        
        search.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(search)
        
        NSLayoutConstraint.activate([
            search.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 7),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        searchBar = search
    }
    
    private func addStubImageView() {
        
        let image = UIImage(named: "stub_trackers") ?? UIImage()
        
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor)
        ])
        
        stubLabel = label
    }
}
