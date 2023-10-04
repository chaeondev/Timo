//
//  TaskTableViewCell.swift
//  Timo
//
//  Created by Chaewon on 2023/10/04.
//

import UIKit

class TaskTableViewCell: BaseTableViewCell {
    
    private lazy var titleLabel = UILabel.labelBuilder(text: "Dashboard Design", font: .systemFont(ofSize: 15, weight: .bold), textColor: .darkGray, numberOfLines: 1)
    private lazy var projectOfTaskLabel = UILabel.labelBuilder(text: "⚬ Design Project view UI", font: .systemFont(ofSize: 11), textColor: .systemBlue, numberOfLines: 1)
    private lazy var dateLabel = UILabel.labelBuilder(text: "8/23", font: .systemFont(ofSize: 12), textColor: .darkGray)
    private lazy var subTaskCountImageView = UIImageView.imageViewBuilder(tintColor: .darkGray, image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up")!)
    private lazy var subTaskCountLabel = UILabel.labelBuilder(text: "8", font: .systemFont(ofSize: 12, weight: .medium), textColor: .darkGray)
    private lazy var expectedTimeLabel = UILabel.labelBuilder(text: "Expected :", font: .systemFont(ofSize: 12), textColor: .systemGray)
    private lazy var expectTimeValueLabel = UILabel.labelBuilder(text: "5H", font: .systemFont(ofSize: 12), textColor: .systemBlue)
    private lazy var taskRealTimeLabel = UILabel.labelBuilder(text: "2:34:12", font: .boldSystemFont(ofSize: 13), textAlignment: .center)
    private lazy var taskTimerButton = TimerButton()
        //UIButton.buttonBuilder(image: UIImage(systemName: "play.circle.fill")!)

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
    }
    
    override func configure() {
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = Design.BaseColor.border?.cgColor
        contentView.layer.borderWidth = 1

        [titleLabel, projectOfTaskLabel, dateLabel, subTaskCountImageView, subTaskCountLabel, expectedTimeLabel, expectTimeValueLabel, taskRealTimeLabel, taskTimerButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        //titleLabel.backgroundColor = .blue
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        //projectOfTaskLabel.backgroundColor = .brown
        projectOfTaskLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel).offset(4)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(projectOfTaskLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        
        subTaskCountImageView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(12)
        }
        
        subTaskCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(subTaskCountImageView.snp.trailing).offset(4)
        }
        
        expectedTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(subTaskCountLabel.snp.trailing).offset(12)
        }
        
        expectTimeValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(expectedTimeLabel.snp.trailing).offset(4)
        }
        //taskRealTimeLabel.backgroundColor = .brown
        taskRealTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(26)
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        //taskTimerButton.backgroundColor = .gray
        taskTimerButton.snp.makeConstraints { make in
            make.top.equalTo(taskRealTimeLabel.snp.bottom).offset(6)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
            make.centerX.equalTo(taskRealTimeLabel)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(self.taskTimerButton.snp.height)
        }
        
        
        
        
    }
    

}
