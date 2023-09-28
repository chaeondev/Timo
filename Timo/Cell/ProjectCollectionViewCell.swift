//
//  ProjectCollectionViewCell.swift
//  Timo
//
//  Created by Chaewon on 2023/09/26.
//

import UIKit

class ProjectCollectionViewCell: BaseCollectionViewCell {
    
    let colorbar = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
//        view.backgroundColor = .lightGray
        view.text = "Design Project view UI setting"
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    let boundaryline = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    let doneButton = {
        let view = UIButton()
        view.setTitle("Doing", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let ddayLabel = {
        let view = UILabel()
//        view.backgroundColor = .lightGray
        view.text = "D-17"
        view.textColor = .black
        view.font = .systemFont(ofSize: 12, weight: .bold)
        return view
    }()
    
    let progressbar = {
        let view = UIProgressView()
        view.trackTintColor = .lightGray
        view.progressTintColor = .orange
        view.progress = 0.3
        return view
    }()
    
    let progressLabel = {
        let view = UILabel()
        view.text = "33%"
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.textColor = .darkGray
        return view
    }()
    
    let taskImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "link")
        view.tintColor = .darkGray
        return view
    }()
    
    let taskCountLabel = {
        let view = UILabel()
        view.text = "23"
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.textColor = .darkGray
        return view
    }()
    
    let timeImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "clock")
        view.tintColor = .darkGray
        return view
    }()
    
    let realTimeLabel = {
        let view = UILabel()
        view.text = "9H"
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.textColor = .darkGray
        return view
    }()
    
    override func configure() {
        
        contentView.addSubview(colorbar)
        contentView.addSubview(titleLabel)
        contentView.addSubview(boundaryline)
        contentView.addSubview(doneButton)
        contentView.addSubview(ddayLabel)
        contentView.addSubview(progressbar)
        contentView.addSubview(progressLabel)
        contentView.addSubview(taskImageView)
        contentView.addSubview(taskCountLabel)
        contentView.addSubview(timeImageView)
        contentView.addSubview(realTimeLabel)
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
            make.bottom.equalToSuperview().inset(8)
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
    
}
