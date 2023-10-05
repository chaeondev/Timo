//
//  ProjectDetailViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/10/04.
//

import UIKit

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
        view.rowHeight = 105
        view.sectionFooterHeight = 80
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Design Project View UI"
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
}

extension ProjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Tasks"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? TaskTableViewCell else { return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerView") as? ProjectDetailFooterView else { return UIView() }
        return view
    }
    
    
}
