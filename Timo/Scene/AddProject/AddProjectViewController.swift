//
//  AddProjectViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/30.
//

import UIKit

class AddProjectViewController: BaseViewController {
    
    // 프로젝트 이름
    let titleLabel = {
        let view = UILabel()
        view.text = "프로젝트 이름"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = Design.BaseColor.text
        return view
    }()
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "프로젝트 이름을 입력해주세요"
        view.borderStyle = .none
        view.textColor = Design.BaseColor.text
        return view
    }()
    
    let titleBorderline = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //프로젝트 기간
    let dateLabel = {
        let view = UILabel()
        view.text = "프로젝트 기간"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = Design.BaseColor.text
        return view
    }()
    
    let startDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        return view
    }()
    
    let periodLabel = {
        let view = UILabel()
        view.text = "~"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .lightGray
        return view
    }()
    
    let endDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        return view
    }()
    
    private lazy var dateStackView = {
        let view = UIStackView(arrangedSubviews: [startDatePicker, periodLabel, endDatePicker])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    let dateBorderline = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //프로젝트 색상
    
    let colorLabel = {
        let view = UILabel()
        view.text = "프로잭트 색상 선택"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = Design.BaseColor.text
        return view
    }()
    
    let colorWell = {
        let view = UIColorWell(frame: .zero)
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupSheet()
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleBorderline)
        view.addSubview(dateLabel)
        view.addSubview(dateStackView)
        view.addSubview(dateBorderline)
        view.addSubview(colorLabel)
        view.addSubview(colorWell)
        
        
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
        title = "새 프로젝트"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelBarButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(okBarButtonClicked))
    }
    
    @objc func cancelBarButtonClicked() {
        
    }
    
    @objc func okBarButtonClicked() {
        
    }
}
