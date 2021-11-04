//
//  WBCalendar.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/03.
//

import UIKit

class WBCalendarView: UIView {
    private let calendarManager = CalendarManager()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let thisMonthLabel = UILabel()
    private let prevMonthButton = UIButton()
    private let nextMonthButton = UIButton()
    private let weekStackView = UIStackView()
    
    private var selectedDate = Date()
    private var totalSquares = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureCalendar()
    }
    
    private func configureCalendar() {
        self.configureMonth()
        self.configureWeek()
        self.configureButton()
        self.configureCollectionView()
        self.configureMonthView()
    }
    
    private func configureThisMonth() {
        thisMonthLabel.text = calendarManager.year(baseDate: selectedDate) + "년 " + calendarManager.month(baseDate: selectedDate) + "월"
    }
    
    private func configureMonth() {
        self.addSubview(thisMonthLabel)
        self.addSubview(prevMonthButton)
        self.addSubview(nextMonthButton)
        self.configureThisMonth()
        self.thisMonthLabel.textColor = UIColor(named: "LabelPurple")
        self.thisMonthLabel.font = .boldSystemFont(ofSize: 17)
        self.prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        self.nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        self.thisMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        self.prevMonthButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.thisMonthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.thisMonthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.thisMonthLabel.widthAnchor.constraint(equalToConstant: thisMonthLabel.intrinsicContentSize.width + 10),
            self.prevMonthButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor),
            self.nextMonthButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor),
            self.prevMonthButton.trailingAnchor.constraint(equalTo: self.thisMonthLabel.leadingAnchor),
            self.prevMonthButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.nextMonthButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.nextMonthButton.leadingAnchor.constraint(equalTo: self.thisMonthLabel.trailingAnchor)
        ])
    }
    
    private func configureWeek() {
        self.addSubview(weekStackView)
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.thisMonthLabel.bottomAnchor, constant: 30),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        self.weekStackView.axis = .horizontal
        self.weekStackView.addArrangedSubview(weekLabel(text: "일"))
        self.weekStackView.addArrangedSubview(weekLabel(text: "월"))
        self.weekStackView.addArrangedSubview(weekLabel(text: "화"))
        self.weekStackView.addArrangedSubview(weekLabel(text: "수"))
        self.weekStackView.addArrangedSubview(weekLabel(text: "목"))
        self.weekStackView.addArrangedSubview(weekLabel(text: "금"))
        self.weekStackView.addArrangedSubview(weekLabel(text: "토"))
        self.weekStackView.distribution = .fillEqually
    }
    
    private func weekLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "LabelPurple")
        label.textAlignment = .center
        return label
    }
    
    private func configureButton() {
        self.prevMonthButton.addTarget(self, action: #selector(minusMonth), for: .touchUpInside)
        self.nextMonthButton.addTarget(self, action: #selector(plusMonth), for: .touchUpInside)
    }
    
    @objc private func minusMonth(_ sender: UIButton) {
        self.selectedDate = calendarManager.minusMonth(baseDate: selectedDate)
        self.configureThisMonth()
        self.configureMonthView()
    }
    
    @objc private func plusMonth(_ sender: UIButton) {
        self.selectedDate = calendarManager.plusMonth(baseDate: selectedDate)
        self.configureThisMonth()
        self.configureMonthView()
    }
    
    private func configureCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(WBCalendarViewCell.self, forCellWithReuseIdentifier: WBCalendarViewCell.identifer)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureMonthView() {
        let numOfDaysInMonth = calendarManager.numOfDaysInMonth(baseDate: selectedDate)
        let firstOfMonth = calendarManager.firstOfMonth(baseDate: selectedDate)
        let weekDay = calendarManager.weekDay(baseDate: firstOfMonth)
        var count: Int = 1
        
        self.totalSquares.removeAll()
        while(count <= 42) {
            if(count <= weekDay || count - weekDay > numOfDaysInMonth) {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - weekDay))
            }
            count += 1
        }
        self.configureThisMonth()
        self.collectionView.reloadData()
    }
}

extension WBCalendarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBCalendarViewCell.identifer, for: indexPath) as? WBCalendarViewCell else { return UICollectionViewCell() }
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.size.width) / 7
        let height = (self.frame.size.width) / 6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}