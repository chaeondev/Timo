//
//  ProjectListViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/09/25.
//

import UIKit
import RealmSwift

class ProjectListViewController: BaseViewController {
    
    private lazy var segmentedControl = {
        let view = UnderlineSegmentedControl(items: [
            "projectFilter_first".localized, "projectFilter_second".localized, "projectFilter_third".localized])
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
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
    
    private lazy var noProjectImageView = UIImageView.imageViewBuilder(image: UIImage(named: "ProjectIconLight")!)
    private lazy var noProjectLabel = UILabel.labelBuilder(text: "생성된 프로젝트가 없어요!", font: .boldSystemFont(ofSize: 16), textColor: Design.BaseColor.border!, numberOfLines: 1, textAlignment: .center)
    
    let viewModel = ProjectListViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        viewModel.updateDataByIndex()
        
        viewModel.checkTimerCounting { [weak self] projectData, taskData in
            let projectDetailVC = ProjectDetailViewController()
            let timerVC = TimerViewController()
            
            projectDetailVC.projectData = projectData
            self?.navigationController?.pushViewController(projectDetailVC, animated: false)
            
            timerVC.taskData = taskData
            self?.navigationController?.pushViewController(timerVC, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationbar()
        
        bindData()
        viewModel.updateDataByIndex()
        
    }
    
    
    func bindData() {
        viewModel.projectList.bind { [weak self] list in
            self?.collectionView.reloadData()
            self?.setNoDataImage(isEmpty: list.isEmpty)
        }
        viewModel.segmentIndex.bind { [weak self] index in
            self?.viewModel.updateDataByIndex()
        }
    }


    
    override func configure() {
        super.configure()
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(noProjectImageView)
        view.addSubview(noProjectLabel)
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
        
        noProjectImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-100)
            make.size.equalTo(120)
        }
        
        noProjectLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(noProjectImageView.snp.bottom).offset(12)
        }
    }
    
    @objc private func segmentedControlValueChanged() {
        viewModel.segmentIndex.value = segmentedControl.selectedSegmentIndex
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
        transitionView(menuType: .add, projectData: nil)
    }

}

extension ProjectListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.projectList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProjectCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.projectDataForIndex(index: indexPath.item)
        cell.data = data
        cell.delegate = self
        cell.configureCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProjectDetailViewController()
        
        let projectData = viewModel.projectDataForIndex(index: indexPath.item)
        viewModel.setUserDefaultsWithProjectData(projectData: projectData)
        
        vc.projectData = projectData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.item)
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            
            let edit = UIAction(title: "edit_contextmenu".localized, image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                
                self.transitionView(menuType: .edit, projectData: self.viewModel.projectList.value[index])
                
            }
            let delete = UIAction(title: "delete_contextmenu".localized, image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                
                self.showAlertMessage(title: "project_delete_title".localized, message: "project_delete_alert_message".localized) {
                    self.viewModel.deleteProjectAtIndex(index: index)
                }
                
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

extension ProjectListViewController: AddProjectDelegate, ProjectCellDelegate {
    
    //AddView의 delegate 메서드
    func updateCollectionView() {
        viewModel.updateDataByIndex()
    }
    
    func updateDoneToCollectionView() {
        viewModel.updateDataByIndex()
    }
}

extension ProjectListViewController {
    
    func setNoDataImage(isEmpty: Bool) {
        noProjectImageView.isHidden = !isEmpty
        noProjectLabel.isHidden = !isEmpty
    }
    
    //AddProject 화면 전환 (추가, 편집)
    func transitionView(menuType: ProjectMenuType, projectData: ProjectTable?) {
        
        let vc = AddProjectViewController()
        vc.menuType = menuType
        vc.projectData = projectData
        vc.addDelegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        present(nav, animated: true)
        
    }
    
}
