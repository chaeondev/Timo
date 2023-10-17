//
//  AddTaskViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/10/05.
//

import UIKit
import RealmSwift

protocol AddTaskDelegate: AnyObject {
    func updateTableView()
}

class AddTaskViewController: BaseViewController {
    
    // 프로젝트 이름
    private lazy var titleLabel = UILabel.labelBuilder(text: "Task 이름", font: .boldSystemFont(ofSize: 16))
    private lazy var titleImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "highlighter")!)
    private lazy var titleTextField = UITextField.textFieldBuilder(placeholder: "Task 이름을 입력해주세요")
    private lazy var titleBorderline = UIView.barViewBuilder(color: .lightGray)
    
    // 마감 날짜
    private lazy var deadlineLabel = UILabel.labelBuilder(text: "Task 일정", font: .boldSystemFont(ofSize: 16))
    private lazy var deadlineImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "calendar")!)
    private lazy var deadlineTextField = UITextField.textFieldBuilder(placeholder: "일정을 입력해주세요")
    private lazy var deadlineDatePicker = UIDatePicker.datePickerBuilder(datePickerStyle: .inline)
    private lazy var deadlineBorderline = UIView.barViewBuilder(color: .lightGray)
    
    // 예상 시간
    private lazy var expectedTimeLabel = UILabel.labelBuilder(text: "Task 예상소요시간", font: .boldSystemFont(ofSize: 16))
    private lazy var expectedTimeImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "clock")!)
    private lazy var expectedTimeTextField = UITextField.textFieldBuilder(placeholder: "예상시간을 입력해주세요")
    private lazy var expectedTimePicker = UIDatePicker.datePickerBuilder(datePickerMode: .countDownTimer, datePickerStyle: .wheels)
    
    
    //MenuType
    var menuType: TaskMenuType = .add
    var taskData: TaskTable?
    
    private var isSaved: Bool = false
    var delegate: AddTaskDelegate?
    
    var project: ProjectTable?
    let taskRepository = TaskTableRepository()
    
    var viewModel = AddTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        
        setNavigationBar()
        setupDatePicker()
        setupSheet()
        
        setEditView()
        
    }
    
    override func configure() {
        super.configure()
        
        [titleLabel, titleImageView, titleTextField, titleBorderline, deadlineLabel ,deadlineImageView, deadlineTextField, deadlineBorderline, expectedTimeLabel, expectedTimeImageView, expectedTimeTextField].forEach {
            view.addSubview($0)
        }
        
        titleTextField.addTarget(self, action: #selector(titleTextFieldChanged), for: .editingChanged)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(30)
            make.size.equalTo(28)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.centerY.equalTo(titleImageView)
            make.leading.equalTo(deadlineImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        titleBorderline.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(titleBorderline.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        deadlineImageView.snp.makeConstraints { make in
            make.top.equalTo(deadlineLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(30)
            make.size.equalTo(28)
        }
        
        deadlineTextField.snp.makeConstraints { make in
            make.centerY.equalTo(deadlineImageView)
            make.leading.equalTo(deadlineImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        deadlineBorderline.snp.makeConstraints { make in
            make.top.equalTo(deadlineTextField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        expectedTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(deadlineBorderline.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(30)
        }
        
        expectedTimeImageView.snp.makeConstraints { make in
            make.top.equalTo(expectedTimeLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(30)
            make.size.equalTo(28)
        }

        expectedTimeTextField.snp.makeConstraints { make in
            make.centerY.equalTo(expectedTimeImageView)
            make.leading.equalTo(expectedTimeImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
    
    //viewModel data 연결
    func bindData() {
        viewModel.title.bind { text in
            self.titleTextField.text = text
        }
        viewModel.isValid.bind { bool in
            self.navigationItem.rightBarButtonItem?.isEnabled = bool
            self.navigationItem.rightBarButtonItem?.tintColor = bool ? .systemBlue : .systemGray
        }
    }
    
    //viewModel checkValidation -> textField 바뀔때마다
    @objc func titleTextFieldChanged() {
        viewModel.title.value = titleTextField.text!
        viewModel.checkValidation()
        
    }
    
    //textField안에 datepicker 설정
    func setupDatePicker() {
        
        deadlineDatePicker.backgroundColor = Design.BaseColor.mainBackground
        deadlineDatePicker.tintColor = Design.BaseColor.mainPoint?.withAlphaComponent(0.8)
        
        deadlineTextField.inputView = deadlineDatePicker
        deadlineDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        expectedTimePicker.backgroundColor = Design.BaseColor.mainBackground
        
        expectedTimeTextField.inputView = expectedTimePicker
        expectedTimePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yy-MM-dd"
          deadlineTextField.text = dateFormatter.string(from: sender.date)
     }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H시간 mm분"
        expectedTimeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func toolBarDoneButtonClicked(){
        self.view.endEditing(true)
    }
}

extension AddTaskViewController {
    //Navigationbar 설정
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
            title = "Task 생성"
        case .edit:
            title = "Task 편집"
        }
    }
    
    @objc func cancelBarButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func saveBarButtonClicked() {
        
        guard let title = titleTextField.text else { return }
        
        if viewModel.isValid.value {
            let expectedTime = (expectedTimePicker.countDownDuration == 60) ? nil : Int(expectedTimePicker.countDownDuration)
            let deadline = (deadlineTextField.text!.isEmpty) ? nil : deadlineDatePicker.date
            
            let taskItem = TaskTable(title: title, savedDate: Date(), date: deadline, expectedTime: expectedTime, realTime: 0, timerStart: nil, timerStop: nil)
            
            switch menuType {
            case .add:
                guard let project else { return }
                taskRepository.createItem(taskItem, project: project)
            case .edit:
                guard let taskData else { return }
                taskRepository.updateItem {
                    taskData.title = title
                    taskData.date = deadlineDatePicker.date
                    taskData.expectedTime = Int(expectedTimePicker.countDownDuration) //nil의 경우 삽입 필요
                }
            }
            
            //call delegate -> collectionview reload 위해서
            delegate?.updateTableView()
            
            dismiss(animated: true)
        } else {
            // TODO: Alert 띄우기 -> 프로젝트 이름을 입력해주세요
        }
        
        }
    
    // sheetPresentationController 설정
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
    }
    
}

extension AddTaskViewController {
    
    private func setEditView() {
        guard let taskData else { return }
        if menuType == .edit {
            titleTextField.text = taskData.title
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy-MM-dd"
            deadlineDatePicker.date = taskData.date ?? Date()
            deadlineTextField.text = dateFormatter.string(from: deadlineDatePicker.date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "H시간mm분"
            expectedTimePicker.countDownDuration = TimeInterval(taskData.expectedTime ?? 0)
            expectedTimeTextField.text = timeFormatter.string(from: expectedTimePicker.date)
            viewModel.title.value = titleTextField.text!
            viewModel.checkValidation()
        }
    }
    
}
