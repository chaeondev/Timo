//
//  ProjectDashboardView.swift
//  Timo
//
//  Created by Chaewon on 2023/10/05.
//

import UIKit

final class ProjectDashboardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        layer.cornerRadius = 12
        layer.borderColor = Design.BaseColor.border?.cgColor
        layer.borderWidth = 1
        backgroundColor = .systemGray6
    }
    
    
}


