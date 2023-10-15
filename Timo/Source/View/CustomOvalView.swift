//
//  CustomOvalView.swift
//  Timo
//
//  Created by Chaewon on 2023/10/14.
//

import UIKit

class CustomOvalView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        let ovalPath = UIBezierPath()
        ovalPath.move(to: CGPoint(x: 161.2, y: 35.01))
        ovalPath.addCurve(to: CGPoint(x: 318.99, y: 93.42), controlPoint1: CGPoint(x: 203.28, y: 33.85), controlPoint2: CGPoint(x: 286.26, y: 42.02))
        ovalPath.addCurve(to: CGPoint(x: 262.89, y: 246.44), controlPoint1: CGPoint(x: 351.71, y: 144.81), controlPoint2: CGPoint(x: 362.23, y: 224.24))
        ovalPath.addCurve(to: CGPoint(x: 53.68, y: 246.44), controlPoint1: CGPoint(x: 163.54, y: 268.63), controlPoint2: CGPoint(x: 108.76, y: 276.15))
        ovalPath.addCurve(to: CGPoint(x: 30.3, y: 93.42), controlPoint1: CGPoint(x: -1.4, y: 216.73), controlPoint2: CGPoint(x: -4.76, y: 136.64))
        ovalPath.addCurve(to: CGPoint(x: 161.2, y: 35.01), controlPoint1: CGPoint(x: 65.36, y: 50.2), controlPoint2: CGPoint(x: 119.13, y: 36.18))
        ovalPath.close()
  
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = ovalPath.cgPath
        self.layer.mask = shapeLayer
        self.layer.masksToBounds = true
    }
    
}
