//
//  AddTaskViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/10/05.
//

import UIKit
import RealmSwift

protocol AddTaskDelegate {
    func updateTableView()
}

class AddTaskViewController: BaseViewController {
    
    // 프로젝트 이름
    private lazy var titleLabel = UILabel.labelBuilder(text: "Task 이름", font: .boldSystemFont(ofSize: 16))
    private lazy var titleTextField = UITextField.textFieldBuilder(placeholder: "Task 이름을 입력해주세요")
    private lazy var titleBorderline = UIView.barViewBuilder(color: .lightGray)
    
    // 마감 날짜
    private lazy var deadlineImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "calendar")!)
    private lazy var deadlineTextField = {
        let view = UnderlineTextField()
        view.setPlaceholder(placeholder: "일정")
        view.textAlignment = .center
        return view
    }()
         
    private lazy var deadlineDatePicker = UIDatePicker.datePickerBuilder(datePickerStyle: .inline)
    // 예상 시간
    private lazy var expectedTimeImageView = UIImageView.imageViewBuilder(image: UIImage(systemName: "clock")!)
    private lazy var expectedTimeTextField = {
        let view = UnderlineTextField()
        view.setPlaceholder(placeholder: "예상시간")
        view.textAlignment = .center
        return view
    }()
    private lazy var timeLabel = UILabel.labelBuilder(text: "시간", font: .systemFont(ofSize: 16))
    
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
        setupTimeTextField()
        setupSheet()
        
    }
    
    override func configure() {
        super.configure()
        
        [titleLabel, titleTextField, titleBorderline, deadlineImageView, deadlineTextField, expectedTimeImageView, expectedTimeTextField, timeLabel].forEach {
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
        
        deadlineImageView.snp.makeConstraints { make in
            make.top.equalTo(titleBorderline.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(30)
            make.size.equalTo(40)
        }
        
        deadlineTextField.snp.makeConstraints { make in
            make.centerY.equalTo(deadlineImageView)
            make.leading.equalTo(deadlineImageView.snp.trailing).offset(12)
            make.width.equalTo(100)
        }
        
        expectedTimeImageView.snp.makeConstraints { make in
            make.top.equalTo(deadlineImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(30)
            make.size.equalTo(40)
        }

        expectedTimeTextField.snp.makeConstraints { make in
            make.centerY.equalTo(expectedTimeImageView)
            make.leading.equalTo(expectedTimeImageView.snp.trailing).offset(12)
            make.width.equalTo(100)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(expectedTimeImageView)
            make.leading.equalTo(expectedTimeTextField.snp.trailing).offset(8)
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
    
    //Navigationbar 설정
    private func setNavigationBar() {
        title = "Task 생성"
        let cancelButton = UIBarButtonItem(title: "navigation_cancel_button".localized, style: .plain, target: self, action: #selector(cancelBarButtonClicked))
        cancelButton.tintColor = .systemRed
        
        let saveButton = UIBarButtonItem(title: "navigation_save_button".localized, style: .plain, target: self, action: #selector(saveBarButtonClicked))
        saveButton.tintColor = isSaved ? .systemBlue : .systemGray
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func cancelBarButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func saveBarButtonClicked() {
        
        guard let title = titleTextField.text else { return }
        if viewModel.isValid.value {
            
            let taskItem = TaskTable(title: title, savedDate: Date(), date: deadlineDatePicker.date, expectedTime: Int(expectedTimeTextField.text ?? "0"), realTime: 0, completed: false)
            
            guard let project else { return }
            taskRepository.createItem(taskItem, project: project)
            
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
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
    }
    
    //timeTextField -> 숫자만 입력하게
    func setupTimeTextField() {
        expectedTimeTextField.keyboardType = .numberPad
    }
    
    //textField안에 datepicker 설정
    func setupDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target : nil, action: #selector(toolBarDoneButtonClicked))
        toolbar.setItems([doneButton], animated: true)
            
        deadlineTextField.inputAccessoryView = toolbar
        deadlineTextField.inputView = deadlineDatePicker
        deadlineDatePicker.addTarget(self, action: #selector(datePickerValueChanged(sender: )), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yy-MM-dd"
          deadlineTextField.text = dateFormatter.string(from: sender.date)
     }
    
    @objc func toolBarDoneButtonClicked(){
        self.view.endEditing(true)
    }
}

// TODO: 시간 단위 제한 더 구현하기
//extension AddTaskViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let allowCharacters = CharacterSet.decimalDigits
//        let characters = CharacterSet(charactersIn: string)
//        return allowCharacters.isSuperset(of: characters)
//    }
//}
