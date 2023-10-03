//
//  ImageViewBuilder.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import UIKit

extension UIImageView {
    static func imageViewBuilder(tintColor: UIColor = .darkGray, image: UIImage) -> UIImageView {
        let view = UIImageView()
        view.image = image
        view.tintColor = tintColor
        view.contentMode = .scaleAspectFill
        return view
    }
    
}
