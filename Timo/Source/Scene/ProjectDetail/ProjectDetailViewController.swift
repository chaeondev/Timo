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
    private lazy var totalHourTitleLabel = UILabel.labelBuilder(text: "project_total_hour_title".localized, font: .boldSystemFont(ofSize: 14), numberOfLines: 1, textAlignment: .center)
    private lazy var totalHourValueLabel = UILabel.labelBuilder(text: "25:34:12", font: .boldSystemFont(ofSize: 13), textColor: Design.BaseColor.border!, numberOfLines: 1, textAlignment: .center)
    
    private lazy var totalTaskView = ProjectDashboardView()
    private lazy var totalTaskTitleLabel = UILabel.labelBuilder(text: "project_total_task_status".localized, font: .boldSystemFont(ofSize: 14), numberOfLines: 1, textAlignment: .center)
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
    let viewModel = ProjectDetailViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewModel Observable 연결
        bindData()
        
        // 전달받은 projectData를 viewModel value로 전환 -> bind 다음 연결 부분
        setProjectData()
        
        //projectData.value(ViewModel)에서 가져온 tasks(array형태)
        setTaskData()
        
        setupMenu()
        
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        
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
        tableView.separatorStyle = .none
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
    
    func bindData() {
        viewModel.projectData.bind { [weak self] projectData in
            self?.updateProjectData()
        }
        viewModel.tasks.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            self?.setTotalTaskActivity()
            self?.setTotalWorkingHour()
        }
    }
    
    //projectData bind할때마다 불러오는 메서드. 이 메서드가 맞는지 모르겠음
    func updateProjectData() {
        self.title = viewModel.projectData.value.title
        dateLabel.text = viewModel.getProjectDateRange()
        doneButton.isSelected = viewModel.isProjectDone()
    }
    
    func setProjectData() {
        guard let projectData else { return }
        viewModel.fetchProjectData(projectData: projectData)
    }
    
    func setTaskData() {
        viewModel.fetchTaskData()
    }
    
    @objc func doneButtonClicked() {
        doneButton.isSelected.toggle()
        viewModel.toggleProjectIsDone()
    }
    
    //navigationbarbutton menu 추가
    func setupMenu() {
        let projectEdit = UIAction(title: "project_edit_title".localized, image: UIImage(systemName: "square.and.pencil")) { [weak self] action in
            let data = self?.viewModel.projectData.value
            self?.transitionProjectMenuView(menuType: .edit, projectData: data)
        }
        let projectDelete = UIAction(title: "project_delete_title".localized, image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            self?.showAlertMessage(title: "project_delete_title".localized, message: "project_delete_alert_message".localized, handler: {
                self?.viewModel.deleteProjectData()
                self?.navigationController?.popViewController(animated: true)
            })
        }
        let taskAdd = UIAction(title: "task_create_title".localized, image: UIImage(systemName: "link.badge.plus")) { [weak self] action in
            self?.transitionTaskMenuView(menuType: .add, taskData: nil)
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
        return viewModel.tasks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? TaskTableViewCell else { return UITableViewCell()}
        
        let data = viewModel.tasks.value[indexPath.row]
        cell.taskdata = data
        cell.projectTitle = viewModel.projectData.value.title
        cell.projectOfTaskLabel.isHidden = true
        cell.configureCell()
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
        
        selectedCell.doneButton.isSelected.toggle()
        if selectedCell.doneButton.isSelected {
            selectedCell.titleLabel.attributedText = selectedCell.titleLabel.text?.strikethrough()
        } else {
            selectedCell.titleLabel.attributedText = selectedCell.titleLabel.text?.removeStrikethrough()
        }
     
        viewModel.updateTaskDataIsDoneByIndex(index: indexPath.row)
        
        setTotalTaskActivity()
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerView") as? ProjectDetailFooterView else { return UIView() }
        view.addTaskButton.addTarget(self, action: #selector(addTaskButtonClicked), for: .touchUpInside)
        return view
    }
    
    @objc func addTaskButtonClicked() {
        transitionTaskMenuView(menuType: .add, taskData: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "task_delete_title".localized) { action, view, completionHandler in
            self.showAlertMessage(title: "task_delete_alert_title".localized, message: "task_delete_alert_message".localized) {
                self.viewModel.deleteTaskDataAtIndex(index: indexPath.row)
            }
        }
        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let edit = UIAction(title: "task_edit_title".localized, image: UIImage(systemName: "square.and.pencil"), state: .off) { (_) in
                self.transitionTaskMenuView(menuType: .edit, taskData: self.viewModel.tasks.value[index])
            }
            let delete = UIAction(title: "task_delete_title".localized, image: UIImage(systemName: "trash"), attributes: .destructive, state: .off) { (_) in
                self.showAlertMessage(title: "task_delete_alert_title".localized, message: "task_delete_alert_message".localized) {
                    self.viewModel.deleteTaskDataAtIndex(index: index)
                }
            }
            return UIMenu(title: "Options", image: nil, identifier: nil, options: .displayInline, children: [edit,delete])
        }
        return context
    }
    
}

extension ProjectDetailViewController {
    func setTotalTaskActivity() {

        let (doneTaskCount, totalTaskCount) = viewModel.countTotalTaskActivity()
        if totalTaskCount == 0 {
            totalTaskCountLabel.text = "0 task"
        } else {
            totalTaskCountLabel.text = "\(doneTaskCount)/\(totalTaskCount) task"
        }
        
    }
    func setTotalWorkingHour() {
        let (hours, minutes, seconds) = viewModel.setTotalWorkingHour()
        totalHourValueLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


extension ProjectDetailViewController: AddTaskDelegate, TaskTableCellDelegate, TimerDelegate, EditProjectDelegate {
    
    //AddTaskView
    func updateTableView() {
        viewModel.fetchTaskData()
    }
    
    //CellDelegate
    func passTaskData(data: TaskTable) {
        
        viewModel.setUserDefaultsWithTaskData(data)
        
        let vc = TimerViewController()
        vc.delegate = self
        vc.taskData = data
        navigationController?.pushViewController(vc, animated: true)
    }
    func updateDoneToDetailView() {
        viewModel.fetchTaskData()
    }
    
    //TimerView
    func updateTimerToDetailView() {
        viewModel.fetchTaskData()
    }
    
    //AddProjectView (ProjectEdit할때)
    func updateProjectDetail() {
        setProjectData() // 이거 맞는지 확인하기
    }
    
}

extension ProjectDetailViewController {
    
    //프로젝트 편집하기 화면 전환
    func transitionProjectMenuView(menuType: ProjectMenuType, projectData: ProjectTable?) {
        
        let vc = AddProjectViewController()
        vc.menuType = menuType
        vc.projectData = projectData
        vc.editDelegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        present(nav, animated: true)
        
    }

    //Task 추가하기, 편집하기 화면 전환
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
