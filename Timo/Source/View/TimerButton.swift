//
//  TimerButton.swift
//  Timo
//
//  Created by Chaewon on 2023/10/04.
//

import UIKit

final class TimerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        tintColor = Design.BaseColor.border
        setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold)
        let image = UIImage(systemName: "play.circle.fill", withConfiguration: imageConfig)
        setImage(image, for: .normal)
    }
    
}

extension TimerButton {
    static func timerButtonBuilder(imageSystemName: String, pointSize: CGFloat = 35, title: String? = nil, font: UIFont? = nil) -> UIButton {
        let view = TimerButton()
        view.titleLabel?.font = font
        view.setTitle(title, for: .normal)
        view.tintColor = Design.BaseColor.border
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        let image = UIImage(systemName: imageSystemName, withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        return view
    }
}
