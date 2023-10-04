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
