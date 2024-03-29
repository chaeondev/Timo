//
//  TaskTableViewCell.swift
//  Timo
//
//  Created by Chaewon on 2023/10/04.
//

import UIKit

protocol TaskTableCellDelegate: AnyObject {
    func passTaskData(data: TaskTable)
    func updateDoneToDetailView()
}

class TaskTableViewCell: BaseTableViewCell {
    
    lazy var doneButton = CheckButton()
    lazy var titleLabel = UILabel.labelBuilder(text: "Dashboard Design", font: .systemFont(ofSize: 15, weight: .bold), textColor: .darkGray, numberOfLines: 1)
    lazy var projectOfTaskLabel = UILabel.labelBuilder(text: "⚬ Design Project view UI", font: .systemFont(ofSize: 11), textColor: .systemBlue, numberOfLines: 1)
    private lazy var titleStackView = UIStackView.stackViewBuilder(axis: .vertical, distribution: .equalSpacing, spacing: 4, alignment: .fill)
    
    private lazy var dateLabel = UILabel.labelBuilder(text: "8/23", font: .systemFont(ofSize: 12), textColor: .darkGray)
    private lazy var subTaskCountImageView = UIImageView.imageViewBuilder(tintColor: .darkGray, image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up")!)
    private lazy var subTaskCountLabel = UILabel.labelBuilder(text: "3/8", font: .systemFont(ofSize: 12, weight: .medium), textColor: .darkGray)
    private lazy var expectedTimeLabel = UILabel.labelBuilder(text: "expected_time_label".localized, font: .systemFont(ofSize: 12), textColor: .systemGray)
    private lazy var expectedTimeValueLabel = UILabel.labelBuilder(text: "5H", font: .systemFont(ofSize: 12), textColor: .systemBlue)
    private lazy var taskRealTimeLabel = UILabel.labelBuilder(text: "2:34:12", font: .boldSystemFont(ofSize: 13), textAlignment: .center)
    lazy var taskTimerButton = TimerButton()
    private lazy var timerStackView = UIStackView.stackViewBuilder(axis: .vertical, distribution: .equalSpacing, spacing: 4)
        //UIButton.buttonBuilder(image: UIImage(systemName: "play.circle.fill")!)

    var taskdata: TaskTable?
    var projectTitle: String = ""
    
    var delegate: TaskTableCellDelegate?
    
    private let taskRepository = TaskTableRepository()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24))
    }
    
    override func configure() {
        
        backgroundColor = Design.BaseColor.mainBackground
        selectionStyle = .none
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = Design.BaseColor.border?.cgColor
        contentView.layer.borderWidth = 1

        [titleLabel, projectOfTaskLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [taskRealTimeLabel, taskTimerButton].forEach {
            timerStackView.addArrangedSubview($0)
        }
        
        [doneButton, titleStackView, dateLabel, subTaskCountImageView, subTaskCountLabel, expectedTimeLabel, expectedTimeValueLabel, timerStackView].forEach {
            contentView.addSubview($0)
        }
        
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        taskTimerButton.addTarget(self, action: #selector(timerButtonClicked), for: .touchUpInside)

    }
    
    override func setConstraints() {
        //doneButton.backgroundColor = .blue
        doneButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.size.equalTo(20)
        }
        //titleStackView.backgroundColor = .cyan
        titleStackView.snp.makeConstraints { make in
            make.centerY.equalTo(doneButton)
            make.leading.equalTo(doneButton.snp.trailing).offset(6)
            make.width.equalToSuperview().multipliedBy(0.65)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
        
//        subTaskCountImageView.snp.makeConstraints { make in
//            make.size.equalTo(14)
//            make.centerY.equalTo(dateLabel)
//            make.leading.equalTo(dateLabel.snp.trailing).offset(12)
//        }
//
//        subTaskCountLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(dateLabel)
//            make.leading.equalTo(subTaskCountImageView.snp.trailing).offset(4)
//        }
        
        expectedTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(12)
        }
        
        expectedTimeValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(expectedTimeLabel.snp.trailing).offset(4)
        }

        taskRealTimeLabel.snp.makeConstraints { make in

            make.width.equalTo(contentView).multipliedBy(0.20)
        }

        taskTimerButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(self.taskTimerButton.snp.height)
        }

        timerStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.20)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
    }
    
    override func prepareForReuse() {
        expectedTimeValueLabel.text = nil
        expectedTimeValueLabel.textColor = .systemBlue
    }
 
    func configureCell() {
        guard let taskdata else { return }
        titleLabel.text = taskdata.title
        
        projectOfTaskLabel.text = " ⚬ \(projectTitle)"
        doneButton.isSelected = taskdata.completed

        titleLabel.attributedText = doneButton.isSelected ? titleLabel.text?.strikethrough() : titleLabel.text?.removeStrikethrough()
        
        if let date = taskdata.date {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd"
            dateLabel.text = dateformatter.string(from: date)
        } else {
            dateLabel.text = "날짜없음"
        }
        
        if let expectedTime = taskdata.expectedTime {
            let timeformatter = DateComponentsFormatter()
            timeformatter.allowedUnits = [.hour, .minute]
            timeformatter.unitsStyle = .abbreviated
            
            let formattedString = timeformatter.string(from: TimeInterval(expectedTime))
            expectedTimeValueLabel.text = formattedString
        } else {
            expectedTimeValueLabel.text = "없음"
            expectedTimeValueLabel.textColor = .systemGray
        }
        
        setRealTime(taskdata: taskdata)
        
        
    }
    
    func setRealTime(taskdata: TaskTable) {
        if let val = taskdata.realTime {
            let hours = val / 3600
            let minutes = val / 60 % 60
            let seconds = val % 60
            taskRealTimeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            taskRealTimeLabel.text = "00:00:00"
        }

    }
    
    @objc func doneButtonClicked() {
        doneButton.isSelected.toggle()
        if doneButton.isSelected {
            titleLabel.attributedText = titleLabel.text?.strikethrough()
        } else {
            titleLabel.attributedText = titleLabel.text?.removeStrikethrough()
        }
        
        guard let taskdata else { return }
        taskRepository.updateItem {
            taskdata.completed.toggle()
        }
        
        delegate?.updateDoneToDetailView()
        
    }
    
    @objc func timerButtonClicked() {
        guard let data = taskdata else { return }
        delegate?.passTaskData(data: data)
    }
    
}
