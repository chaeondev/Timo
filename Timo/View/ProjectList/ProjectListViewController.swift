//
//  ProjectListViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/25.
//

import UIKit

class ProjectListViewController: BaseViewController {
    
    lazy var segmentedControl = {
        let view = UISegmentedControl()
        view.insertSegment(withTitle: "ALL", at: 0, animated: true)
        view.insertSegment(withTitle: "Doing", at: 1, animated: true)
        view.insertSegment(withTitle: "Done", at: 2, animated: true)
        view.selectedSegmentIndex = 0
        
        view.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        view.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        view.backgroundColor = .clear

        view.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.lightGray
        ], for: .normal)
        view.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.orange
        ], for: .selected)
        
        return view
    }()
    
    let buttonBar = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChangend), for: .valueChanged)
        
    }
    
    override func configure() {
        super.configure()
        view.addSubview(segmentedControl)
        view.addSubview(buttonBar)
    }
    
    override func setConstraints() {
        super.setConstraints()
        segmentedControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        buttonBar.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.height.equalTo(5)
            make.leading.equalTo(segmentedControl.snp.leading)
            make.width.equalTo(segmentedControl.snp.width).multipliedBy(0.33)
        }
    }
    
    @objc func segmentedControlValueChangend(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / 3) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        }
    }
}
