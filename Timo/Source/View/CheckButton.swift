//
//  CheckButton.swift
//  Timo
//
//  Created by Chaewon on 2023/10/08.
//

import UIKit

final class CheckButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureButton() {
        backgroundColor = .clear
        setImage(UIImage(systemName: "circle"), for: .normal)
        tintColor = Design.BaseColor.border
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
            } else {
                self.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
    }
    
    
}
