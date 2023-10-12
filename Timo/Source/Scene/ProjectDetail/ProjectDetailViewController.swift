//
//  ProjectDetailViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/10/04.
//

import UIKit
import RealmSwift

class ProjectDetailViewController: BaseViewController {
    
    private lazy var dateLabel = UILabel.labelBuilder(text: "23.06.12 - 23.07.13", font: .boldSystemFont(ofSize: 16), numberOfLines: 1, textAlignment: .center)
    private lazy var doneButton = StatusButton()
    
    private lazy var totalHourView = ProjectDashboardView()
    private lazy var totalHourTitleLabel = UILabel.labelBuilder(text: "Total working hour", font: .boldSystemFont(ofSize: 14), numberOfLines: 1, textAlignment: .center)
    private lazy var totalHourValueLabel = UILabel.labelBuilder(text: "25:34:12", font: .boldSystemFont(ofSize: 13), textColor: Design.BaseColor.border!, numberOfLines: 1, textAlignment: .center)
    
    private lazy var totalTaskView = ProjectDashboardView()
    private lazy var totalTaskTitleLabel = UILabel.labelBuilder(text: "Total task activity", font: .boldSystemFont(ofSize: 14), numberOfLines: 1, textAlignment: .center)
    private lazy var totalTaskCountLabel = UILabel.labelBuilder(text: "24/87 task", font: .boldSystemFont(ofSize: 13), textColor: Design.BaseColor.border!, numberOfLines: 1, textAlignment: .center)
    
    private lazy var tableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.register(TaskTableViewCell.self, forCellReuseIdentifier: "tableCell")
        view.register(ProjectDetailFooterView.self, forHeaderFooterViewReuseIdentifier: "footerView")
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 90
        view.sectionFooterHeight = 80
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    var projectData: ProjectTable?
    var taskList: Results<TaskTable>?
    
    private let projectRepository = ProjectTableRepository()
    private let taskRepository = TaskTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProjectData()
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        taskList = projectData?.tasks.sorted(byKeyPath: "savedDate")
        
        setupMenu()
    }
    
    override func configure() {
        super.configure()
        [dateLabel, doneButton, totalHourView, totalTaskView, tableView].forEach {
            view.addSubview($0)
        }
        [totalHourTitleLabel, totalHourValueLabel].forEach {
            totalHourView.addSubview($0)
        }
        [totalTaskTitleLabel, totalTaskCountLabel].forEach {
            totalTaskView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        //dateLabel.backgroundColor = .gray
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(65)
        }
        
        totalHourView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(self.totalHourView.snp.width).multipliedBy(0.36)
        }
        
        totalHourTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        totalHourValueLabel.snp.makeConstraints { make in
            make.top.equalTo(totalHourTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        totalTaskView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(self.totalTaskView.snp.width).multipliedBy(0.36)
        }
        
        totalTaskTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        totalTaskCountLabel.snp.makeConstraints { make in
            make.top.equalTo(totalTaskTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(totalHourView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func doneButtonClicked() {
        doneButton.isSelected.toggle()
        guard let projectData else { return }
        projectRepository.updateItem {
            projectData.done.toggle()
        }
    }
    
    func setProjectData() {
        guard let projectData else { return }
        title = projectData.title
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yy.MM.dd"
        
        guard let startdate = projectData.startDate else { return }
        guard let enddate = projectData.endDate else { return }
        dateLabel.text = "\(dateformatter.string(from: startdate)) - \(dateformatter.string(from: enddate))"
        
        doneButton.isSelected = projectData.done
    }
    
    //navigationbarbutton menu 추가
    func setupMenu() {
        let projectEdit = UIAction(title: "프로젝트 편집", image: UIImage(systemName: "square.and.pencil")) { [weak self] action in
            guard let data = self?.projectData else { return }
            self?.transitionProjectMenuView(menuType: .edit, projectData: data)
        }
        let projectDelete = UIAction(title: "프로젝트 삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            guard let data = self?.projectData else { return }
            self?.showAlertMessage(title: "프로젝트 삭제", message: "해당 프로젝트 삭제 시, 하위 Task들과 기록한 시간이 삭제됩니다. 삭제하시겠습니까?", handler: {
                self?.projectRepository.deleteItem(data)
                self?.navigationController?.popViewController(animated: true)
            })
        }
        let taskAdd = UIAction(title: "Task 추가", image: UIImage(systemName: "link.badge.plus")) { [weak self] action in
            self?.transitionAddTaskView()
        }
        
        let projectMenu = UIMenu(options: .displayInline, children: [projectEdit, projectDelete])
        let taskMenu = UIMenu(options: .displayInline, children: [taskAdd])
        let mainMenu = UIMenu(children: [projectMenu, taskMenu])
        
        let barButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: mainMenu)
        
        navigationItem.rightBarButtonItem = barButton
    }
}

extension ProjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Tasks"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taskList = taskList else { return 0 }
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? TaskTableViewCell else { return UITableViewCell()}
        
        if let taskList, let projectData {
            let data = taskList[indexPath.row]
            cell.taskdata = data
            cell.projectTitle = projectData.title
            cell.projectOfTaskLabel.isHidden = true
            cell.configureCell()
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
        guard let taskList else { return }
        
        let data = taskList[indexPath.row]
        
        selectedCell.doneButton.isSelected.toggle()
        if selectedCell.doneButton.isSelected {
            selectedCell.titleLabel.attributedText = selectedCell.titleLabel.text?.strikethrough()
        } else {
            selectedCell.titleLabel.attributedText = selectedCell.titleLabel.text?.removeStrikethrough()
        }
     
        taskRepository.updateItem {
            data.completed.toggle()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerView") as? ProjectDetailFooterView else { return UIView() }
        view.addTaskButton.addTarget(self, action: #selector(addTaskButtonClicked), for: .touchUpInside)
        return view
    }
    
    @objc func addTaskButtonClicked() {
        transitionAddTaskView()
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let edit = UIAction(title: "편집하기", image: UIImage(systemName: "square.and.pencil"), state: .off) { (_) in
                guard let taskList = self.taskList else { return }
                self.transitionTaskMenuView(menuType: .edit, taskData: taskList[index])
            }
            let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive, state: .off) { (_) in
                guard let taskList = self.taskList else { return }
                self.showAlertMessage(title: "Task 삭제", message: "해당 Task에 기록된 시간도 함께 삭제됩니다. 삭제하시겠습니까?") {
                    self.taskRepository.deleteItem(taskList[index])
                    self.tableView.reloadData()
                }
            }
            return UIMenu(title: "Options", image: nil, identifier: nil, options: .displayInline, children: [edit,delete])
        }
        return context
    }
    
}

extension ProjectDetailViewController {
    
}

extension ProjectDetailViewController: AddTaskDelegate, TaskTableCellDelegate, TimerDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
    
    func passTaskData(data: TaskTable) {
        let vc = TimerViewController()
        vc.delegate = self
        vc.taskData = data
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

extension ProjectDetailViewController {
    
    //프로젝트 편집하기 화면 전환
    func transitionProjectMenuView(menuType: ProjectMenuType, projectData: ProjectTable?) {
        
        let vc = AddProjectViewController()
        vc.menuType = menuType
        vc.projectData = projectData
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        present(nav, animated: true)
        
    }
    
    //Task 추가 화면 전환
    func transitionAddTaskView() {
        let vc = AddTaskViewController()
        vc.project = projectData
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        present(nav, animated: true)
    }
    
    //Task 편집하기 화면 전환
    func transitionTaskMenuView(menuType: TaskMenuType, taskData: TaskTable?) {
        let vc = AddTaskViewController()
        vc.menuType = menuType
        vc.taskData = taskData
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        present(nav, animated: true)
    }
    
    
}
