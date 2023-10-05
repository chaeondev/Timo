//
//  ProjectListViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/25.
//

import UIKit
import RealmSwift

class ProjectListViewController: BaseViewController, AddProjectDelegate {
    
    private let segmentedControl = {
        let view = UnderlineSegmentedControl(items: [
            "projectFilter_first".localized, "projectFilter_second".localized, "projectFilter_third".localized])
        view.selectedSegmentIndex = 0
        return view
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.backgroundColor = .clear
        view.register(ProjectCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    var projectList: Results<ProjectTable>?
    
    private let projectRepository = ProjectTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationbar()
        
        projectList = projectRepository.fetch()
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
    
    func setNavigationbar() {
        title = "navigation_list_title".localized
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22, weight: .bold),
            NSAttributedString.Key.foregroundColor : Design.BaseColor.border!
        ]
        navigationController?.navigationBar.tintColor = Design.BaseColor.border
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonClicked))
    }
    
    @objc func addBarButtonClicked() {
        let vc = AddProjectViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    //AddView의 delegate 메서드
    func updateCollectionView() {
        collectionView.reloadData()
    }

}

extension ProjectListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let projectList = projectList else { return 0 }
        return projectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProjectCollectionViewCell else { return UICollectionViewCell() }
        
        if let projectList {
            let data = projectList[indexPath.row]
            cell.data = data
            cell.configureCell()

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProjectDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: iOS17 확인
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.item)
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let edit = UIAction(title: "edit_contextmenu".localized, image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                print("edit button clicked")
                //add tasks...
                // TODO: 편집 viewcontroller -> addviewcontroller
            }
            let delete = UIAction(title: "delete_contextmenu".localized, image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                print("delete button clicked")
                //add tasks...
                // TODO: 삭제 alert -> realm 지우기
            }
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
        }
        return context
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
