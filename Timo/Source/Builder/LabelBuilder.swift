//
//  LabelBuilder.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import UIKit

extension UILabel {
    static func labelBuilder(text: String, font: UIFont, textColor: UIColor = Design.BaseColor.text ?? UIColor.label, numberOfLines: Int = 0) -> UILabel {
        let view = UILabel()
        view.text = text
        view.font = font
        view.textColor = textColor
        view.numberOfLines = numberOfLines
        return view
    }
}
