//
//  AddProjectViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/30.
//

import UIKit

protocol AddProjectDelegate: AnyObject {
    func updateCollectionView()
}

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
    
    // Menu Type
    var menuType: ProjectMenuType = .add // default 값
    var projectData: ProjectTable? // Edit 화면일 때 해당 프로젝트 Data
    
    // save 버튼 Enable 여부
    private var isSaved: Bool = false
    
    // delegate - collectionView reload
    var delegate: AddProjectDelegate?
    
    let projectRepository = ProjectTableRepository()
    
    var viewModel = AddProjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        setNavigationBar()
        setupSheet()
        projectRepository.checkRealmURL()
        setEditView()
        
    }
    
    override func configure() {
        super.configure()
        

        [startDatePicker, periodLabel, endDatePicker].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        [titleLabel, titleTextField, titleBorderline, dateLabel, dateStackView, dateBorderline, colorLabel, colorWell].forEach {
            view.addSubview($0)
        }
        
        titleTextField.addTarget(self, action: #selector(titleTextFieldChanged), for: .editingChanged)
        
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
    
    func bindData() {
        viewModel.title.bind { text in
            self.titleTextField.text = text
        }
        viewModel.isValid.bind { bool in
            self.navigationItem.rightBarButtonItem?.isEnabled = bool
            self.navigationItem.rightBarButtonItem?.tintColor = bool ? .systemBlue : .systemGray
        }
    }

    @objc func titleTextFieldChanged() {
        viewModel.title.value = titleTextField.text!
        viewModel.checkValidation()
        
    }
    


}

extension AddProjectViewController {
    
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
        setTitle()
        
        let cancelButton = UIBarButtonItem(title: "navigation_cancel_button".localized, style: .plain, target: self, action: #selector(cancelBarButtonClicked))
        cancelButton.tintColor = .systemRed
        
        let saveButton = UIBarButtonItem(title: "navigation_save_button".localized, style: .plain, target: self, action: #selector(saveBarButtonClicked))
        saveButton.tintColor = isSaved ? .systemBlue : .systemGray
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setTitle() {
        switch menuType {
        case .add:
            title = "navigation_create_title".localized
        case .edit:
            title = "navigation_edit_title".localized
        }
    }
    
    @objc func cancelBarButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func saveBarButtonClicked() {
        
        guard let title = titleTextField.text else { return }
        if viewModel.isValid.value {
            let color = colorWell.selectedColor?.toHexString() ?? Design.BaseColor.mainPoint!.toHexString()

            let projectItem = ProjectTable(title: title, savedDate: Date(), startDate: startDatePicker.date, endDate: endDatePicker.date, color: color, done: false)
            
            switch menuType {
                
            case .add:
                projectRepository.createItem(projectItem)
            case .edit:
                guard let projectData else { return }
                projectRepository.updateItem {
                    projectData.title = title
                    projectData.startDate = startDatePicker.date
                    projectData.endDate = endDatePicker.date
                    projectData.color = color
                }
            }

            //call delegate -> collectionview reload 위해서
            delegate?.updateCollectionView()
            
            dismiss(animated: true)
        } else {
            // TODO: Alert 띄우기 -> 프로젝트 이름을 입력해주세요
        }
        
    }
    
}

// MARK: - Edit Menu 화면
extension AddProjectViewController {
    
    private func setEditView() {
        guard let projectData else { return }
        if menuType == .edit {
            titleTextField.text = projectData.title
            startDatePicker.date = projectData.startDate ?? Date()
            endDatePicker.date = projectData.endDate ?? Date()
            colorWell.selectedColor = UIColor(hex: projectData.color!)
            
            viewModel.title.value = titleTextField.text!
            viewModel.checkValidation()
        }
    }
}
