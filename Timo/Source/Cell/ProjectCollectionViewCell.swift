//
//  ProjectCollectionViewCell.swift
//  Timo
//
//  Created by Chaewon on 2023/09/26.
//

import UIKit

protocol ProjectCellDelegate: AnyObject {
    func updateDoneToCollectionView()
}

class ProjectCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var colorbar = UIView.barViewBuilder(color: Design.BaseColor.subPoint!)
    private lazy var titleLabel = UILabel.labelBuilder(text: "Design Project view UI setting", font: .boldSystemFont(ofSize: 14))
    private lazy var boundaryline = UIView.barViewBuilder(color: Design.BaseColor.subPoint!)
    private lazy var doneButton: UIButton = StatusButton()
    private lazy var ddayLabel = UILabel.labelBuilder(text: "D-17", font: .systemFont(ofSize: 12, weight: .bold))
    private lazy var progressbar = {
        let view = UIProgressView()
        view.trackTintColor = .lightGray
        view.progressTintColor = Design.BaseColor.subPoint
        view.progress = 0.3
        return view
    }()
    private lazy var progressLabel = UILabel.labelBuilder(text: "33%", font: .systemFont(ofSize: 11, weight: .medium), textColor: .darkGray)
    private lazy var taskImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "link")!)
    private lazy var taskCountLabel = UILabel.labelBuilder(text: "23", font: .systemFont(ofSize: 11, weight: .medium), textColor: .darkGray)
    private lazy var timeImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "clock")!)
    private lazy var realTimeLabel = UILabel.labelBuilder(text: "9H", font: .systemFont(ofSize: 11, weight: .medium), textColor: .darkGray)
    
    var data: ProjectTable?
    
    var delegate: ProjectCellDelegate?
    
    private let repository = ProjectTableRepository()
    
    override func configure() {
        
        self.backgroundColor = Design.BaseColor.subBackground
        self.layer.cornerRadius = 12
        self.layer.borderColor = Design.BaseColor.border?.cgColor
        self.layer.borderWidth = 1
        
        [colorbar, titleLabel, boundaryline, doneButton, ddayLabel, progressbar, progressLabel, taskImageView, taskCountLabel, timeImageView, realTimeLabel].forEach {
            contentView.addSubview($0)
        }
        
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
    }
    
    override func setConstraints() {
        
        //title 파트
        colorbar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorbar.snp.centerY)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        boundaryline.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        //Button, D-Day 파트
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(boundaryline.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(self.doneButton.snp.width).multipliedBy(0.4)
        }
        
        ddayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(doneButton.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
        //Progress Bar 파트
        progressbar.snp.makeConstraints { make in
            make.top.equalTo(doneButton.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.67)
            make.height.equalTo(5)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(progressbar.snp.centerY).offset(-1)
            make.leading.equalTo(progressbar.snp.trailing).offset(4)
        }
        
        //TaskCount, Time 파트
        taskImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(14)
        }
        
        taskCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(taskImageView.snp.centerY)
            make.leading.equalTo(taskImageView.snp.trailing).offset(4)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(taskImageView.snp.centerY)
            make.leading.equalTo(taskCountLabel.snp.trailing).offset(14)
            make.size.equalTo(14)
        }
        
        realTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(taskImageView.snp.centerY)
            make.leading.equalTo(timeImageView.snp.trailing).offset(4)
        }
    }
    
    func configureCell() {
        guard let data else { return }
        titleLabel.text = data.title
        if let endDate = data.endDate {
            let dday = calculateDateInterval(from: endDate)
            ddayLabel.text = setDDayString(interval: dday)
        }
        doneButton.isSelected = data.done
        colorbar.backgroundColor = UIColor(hex: data.color!)
        boundaryline.backgroundColor = UIColor(hex: data.color!)
        progressbar.progressTintColor = UIColor(hex: data.color!)
        progressbar.progress = calculateProgress()
        progressLabel.text = setProgressLabel()
        taskCountLabel.text = "\(data.tasks.count)"
        setTotalTime()
    }
    
    @objc func doneButtonClicked() {
        doneButton.isSelected.toggle()
        guard let data else { return }
        repository.updateItem {
            data.done.toggle()
        }
        delegate?.updateDoneToCollectionView()
    }
    
    func calculateProgress() -> Float {
        guard let data else { return 0 }
        let allTasksCount = data.tasks.count
        let completedTasksCount = data.tasks.filter("completed == true").count
        
        if allTasksCount == 0 {
            return 0
        } else {
            return Float(completedTasksCount) / Float(allTasksCount)
        }
    }
    
    func setProgressLabel() -> String {
        let progress = calculateProgress()
        let percent = Int(progress * 100)
        return "\(percent)%"
    }
    
    func calculateDateInterval(from endDate: Date) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //str으로 변환(날짜 제외 시간 삭제)
        let endDateStr = dateFormatter.string(from: endDate)
        let todayStr = dateFormatter.string(from: Date())
        
        //다시 Date변환(계산위해서)
        let end = dateFormatter.date(from: endDateStr)
        let today = dateFormatter.date(from: todayStr)
        
        //interval 계산
        let calendar = Calendar.current
        
        if let end, let today {
            let dateGap = calendar.dateComponents([.day], from: end, to: today).day!
            
            return dateGap
        } else {
            return 0 // TODO: d-day 계산 실패 -> alert 필요?
        }
    }
    
    func setDDayString(interval: Int) -> String {
        if interval < 0 {
            return "D\(interval)"
        } else if interval == 0 {
            return "D-Day"
        } else if interval > 0 {
            return "D+\(interval)"
        } else {
            return ""
        }
    }
    
    func setTotalTime() {
        let timeFormatter = DateComponentsFormatter()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en")
        timeFormatter.calendar = calendar
        timeFormatter.allowedUnits = [.hour]
        timeFormatter.unitsStyle = .abbreviated
        
        var totalExpectedTime: Int = 0
        var totalRealTime: Int = 0
        data?.tasks.forEach {
            totalExpectedTime += $0.expectedTime ?? 0
            totalRealTime += $0.realTime ?? 0
        }
        let expectedHour = timeFormatter.string(from: TimeInterval(totalExpectedTime))
        let realHour = timeFormatter.string(from: TimeInterval(totalRealTime))
        
        if let expectedHour, let realHour {
            realTimeLabel.text = "예상: \(expectedHour) 소요: \(realHour)"
        }
        
    }
}
