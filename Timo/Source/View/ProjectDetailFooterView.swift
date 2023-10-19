//
//  ProjectDetailFooterView.swift
//  Timo
//
//  Created by Chaewon on 2023/10/05.
//

import UIKit
import SnapKit

final class ProjectDetailFooterView: UITableViewHeaderFooterView {
    
    lazy var addTaskButton = UIButton.buttonBuilder(image: UIImage(systemName: "plus"), title:  "task_create_title".localized, font: .boldSystemFont(ofSize: 17))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureFooterView()
        setConstraints()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFooterView() {
        addTaskButton.setTitleColor(Design.BaseColor.text, for: .normal)
        contentView.addSubview(addTaskButton)
    }
    
    func setConstraints() {
        addTaskButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(24)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
    }
    
}
