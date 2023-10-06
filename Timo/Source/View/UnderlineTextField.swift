//
//  UnderlineTextField.swift
//  Timo
//
//  Created by Chaewon on 2023/10/06.
//

import UIKit
import SnapKit

class UnderlineTextField: UITextField {
    
    lazy var placeholderColor: UIColor = self.tintColor
    lazy var placeholderString: String = ""
    
    private lazy var underlineView = UIView.barViewBuilder(color: Design.BaseColor.border!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(underlineView)
        
        underlineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder(placeholder: String, color: UIColor = .lightGray) {
        placeholderString = placeholder
        placeholderColor = color
        
        setPlaceholder()
        underlineView.backgroundColor = placeholderColor
    }
    
    func setPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }
    
    func setError(errorMessage: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: errorMessage,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        underlineView.backgroundColor = .red
    }
}

extension UnderlineTextField {
    @objc func editingDidBegin() {
        setPlaceholder()
        underlineView.backgroundColor = self.tintColor
    }
    
    @objc func editingDidEnd() {
        underlineView.backgroundColor = placeholderColor
    }
}
