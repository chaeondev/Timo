//
//  ButtonBuilder.swift
//  Timo
//
//  Created by Chaewon on 2023/10/04.
//

import UIKit

extension UIButton {
    static func buttonBuilder(image: UIImage?, title: String? = nil, font: UIFont? = nil) -> UIButton {
        let view = UIButton()
        view.titleLabel?.font = font
        view.setTitle(title, for: .normal)
        view.setImage(image, for: .normal)
        return view
    }
}
