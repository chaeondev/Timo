//
//  ProjectListViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/25.
//

import UIKit

class ProjectListViewController: BaseViewController {
    
    private let segmentedControl = {
        let view = UnderlineSegmentedControl(items: ["ALL", "Doing", "Done"])
        view.selectedSegmentIndex = 0
        return view
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.backgroundColor = .clear
        view.register(ProjectCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.collectionViewLayout = collectionViewLayout()
        view.keyboardDismissMode = .onDrag
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        segmentedControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension ProjectListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProjectCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let size = UIScreen.main.bounds.width - (spacing * 3)
        let width = size / 2
        let height = width * 0.9    
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
    
    
}
