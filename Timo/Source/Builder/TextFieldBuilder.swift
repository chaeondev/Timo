//
//  TextFieldBuilder.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import UIKit

extension UITextField {
    static func textFieldBuilder(placeholder: String, textColor: UIColor = Design.BaseColor.text!) -> UITextField {
        let view = UITextField()
        view.placeholder = placeholder
        view.textColor = textColor
        view.borderStyle = .none
        return view
    }
    static func underlineTextFieldBuilder(placeholder: String, textColor: UIColor = Design.BaseColor.text!, textAlignment: NSTextAlignment = .center) -> UnderlineTextField {
        let view = UnderlineTextField()
        view.setPlaceholder(placeholder: placeholder)
        view.textColor = textColor
        view.textAlignment = textAlignment
        return view
    }
}
