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
    
    func showAlertMessage(title: String, message: String? = nil, handler: (() -> ())? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            handler?()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
        
    }
    
}
