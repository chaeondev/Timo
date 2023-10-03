//
//  StatusButton.swift
//  Timo
//
//  Created by Chaewon on 2023/09/30.
//

import UIKit

final class StatusButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureButton() {

        backgroundColor = Design.BaseColor.subBackground
        setTitleColor(Design.BaseColor.text, for: .normal)
        setTitle("project_doing".localized, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Design.BaseColor.border?.cgColor
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = Design.BaseColor.border
                self.setTitleColor(Design.BaseColor.mainBackground, for: .selected)
                self.setTitle("project_done".localized, for: .selected)
            } else {
                self.backgroundColor = Design.BaseColor.subBackground
                self.setTitleColor(Design.BaseColor.text, for: .normal)
                self.setTitle("project_doing".localized, for: .normal)
            }
        }
    }
    
    
}
