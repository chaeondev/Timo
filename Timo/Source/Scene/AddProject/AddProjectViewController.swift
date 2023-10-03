//
//  AddProjectViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/30.
//

import UIKit

class AddProjectViewController: BaseViewController {
    
    // 프로젝트 이름
    private lazy var titleLabel = UILabel.labelBuilder(text: "project_title".localized, font: .boldSystemFont(ofSize: 16))
    private lazy var titleTextField = UITextField.textFieldBuilder(placeholder: "project_title_placeholder".localized)
    private lazy var titleBorderline = UIView.barViewBuilder(color: .lightGray)
    
    //프로젝트 기간
    private lazy var dateLabel = UILabel.labelBuilder(text: "project_period".localized, font: .boldSystemFont(ofSize: 16))
    private lazy var startDatePicker = UIDatePicker.datePickerBuilder()
    private lazy var periodLabel = UILabel.labelBuilder(text: "~", font: .boldSystemFont(ofSize: 16), textColor: .lightGray)
    private lazy var endDatePicker = UIDatePicker.datePickerBuilder()
    private lazy var dateStackView = UIStackView.stackViewBuilder(axis: .horizontal, distribution: .equalSpacing, spacing: 8)
    private lazy var dateBorderline = UIView.barViewBuilder(color: .lightGray)
    
    //프로젝트 색상
    private lazy var colorLabel = UILabel.labelBuilder(text: "project_color".localized, font: .boldSystemFont(ofSize: 16))
    private lazy var colorWell = UIColorWell(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupSheet()
    }
    
    override func configure() {
        super.configure()
        

        [startDatePicker, periodLabel, endDatePicker].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        [titleLabel, titleTextField, titleBorderline, dateLabel, dateStackView, dateBorderline, colorLabel, colorWell].forEach {
            view.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        titleBorderline.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleBorderline.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(30)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(30)
        }
        
        dateBorderline.snp.makeConstraints { make in
            make.top.equalTo(dateStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(dateBorderline.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(30)
        }
        
        colorWell.snp.makeConstraints { make in
            make.centerY.equalTo(colorLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(30)
            make.size.equalTo(50)
        }
        
    }
    
    // sheetPresentationController 설정
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
    }
    
    //NavigationBar 세팅
    private func setNavigationBar() {
        title = "navigation_create_title".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "navigation_cancel_button".localized, style: .plain, target: self, action: #selector(cancelBarButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "navigation_ok_button".localized, style: .plain, target: self, action: #selector(okBarButtonClicked))
    }
    
    @objc func cancelBarButtonClicked() {
        
    }
    
    @objc func okBarButtonClicked() {
        
    }
}
