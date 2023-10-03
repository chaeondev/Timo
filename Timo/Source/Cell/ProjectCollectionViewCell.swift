//
//  ProjectCollectionViewCell.swift
//  Timo
//
//  Created by Chaewon on 2023/09/26.
//

import UIKit

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
    private lazy var progressLabel = UILabel.labelBuilder(text: "33%", font: .systemFont(ofSize: 10, weight: .medium), textColor: .darkGray)
    private lazy var taskImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "link")!)
    private lazy var taskCountLabel = UILabel.labelBuilder(text: "23", font: .systemFont(ofSize: 10, weight: .medium), textColor: .darkGray)
    private lazy var timeImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "clock")!)
    private lazy var realTimeLabel = UILabel.labelBuilder(text: "9H", font: .systemFont(ofSize: 10, weight: .medium), textColor: .darkGray)
    
    
    override func configure() {
        
        self.backgroundColor = Design.BaseColor.subBackground
        self.layer.cornerRadius = 12
        self.layer.borderColor = Design.BaseColor.border?.cgColor
        self.layer.borderWidth = 1
        
        [colorbar, titleLabel, boundaryline, doneButton, ddayLabel, progressbar, progressLabel, taskImageView, taskCountLabel, timeImageView, realTimeLabel].forEach {
            contentView.addSubview($0)
        }
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
            make.trailing.equalTo(ddayLabel.snp.leading).inset(4)
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
            make.leading.equalTo(taskCountLabel.snp.trailing).offset(8)
            make.size.equalTo(14)
        }
        
        realTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(taskImageView.snp.centerY)
            make.leading.equalTo(timeImageView.snp.trailing).offset(4)
        }
    }
    
    func configureCell() {
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
    }
    
    @objc func doneButtonClicked() {
        doneButton.isSelected.toggle()
    }
    
}