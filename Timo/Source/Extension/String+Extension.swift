//
//  String+Extension.swift
//  Timo
//
//  Created by Chaewon on 2023/10/08.
//

import UIKit

extension String {
    //취소선 구현
    func strikethrough() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes([
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strikethroughColor: UIColor.systemGray,
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ], range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    func removeStrikethrough() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
        attributedString.removeAttribute(NSAttributedString.Key.strikethroughColor, range: NSMakeRange(0, attributedString.length))
        attributedString.removeAttribute(NSAttributedString.Key.foregroundColor, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttributes([
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.isEmpty,
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ], range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}
