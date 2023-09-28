//
//  BaseViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/25.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {
        view.backgroundColor = Design.BaseColor.mainBackground
    }
    
    func setConstraints() {
        
    }
    
}
