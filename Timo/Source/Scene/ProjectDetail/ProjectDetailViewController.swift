//
//  ProjectDetailViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/10/04.
//

import UIKit

class ProjectDetailViewController: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(TaskTableViewCell.self, forCellReuseIdentifier: "tableCell")
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 105
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ProjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? TaskTableViewCell else { return UITableViewCell()}
        return cell
    }
    
    
}
