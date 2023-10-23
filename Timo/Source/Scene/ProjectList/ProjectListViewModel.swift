//
//  ProjectListViewModel.swift
//  Timo
//
//  Created by Chaewon on 2023/10/20.
//

import Foundation
import RealmSwift

class ProjectListViewModel {
    
    //Realm Repository
    private let projectRepository = ProjectTableRepository()
    private let taskRepository = TaskTableRepository()
    
    //userDefaults
    private let userDefaults = UserDefaults.standard
    
    
    var projectList: CustomObservable<[ProjectTable]> = CustomObservable([])
 
    
    
    //projectList fetch 메서드
    func fetchData() {
        let projects = Array(projectRepository.fetch())
        self.projectList.value = projects
    }
    
    // segmentedControl index에 따라 projectList data 반환
    func fetchDataByIndex(index: Int) -> [ProjectTable] {
        switch index {
        case 0:
            return Array(projectRepository.fetch())
        case 1:
            return Array(projectRepository.fetch().where { $0.done == false })
        case 2:
            return Array(projectRepository.fetch().where { $0.done == true })
        default:
            return []
        }
    }
    // segmentedControl - projectList.value에 반영
    func updateDataByIndex(index: Int) {
        projectList.value = fetchDataByIndex(index: index)
    }
    
}

extension ProjectListViewModel {
    
    //viewWillAppear에서 timer돌아가는지 확인하는 메서드
    func checkTimerCounting(completion: (ProjectTable?, TaskTable?) -> Void) {
        let timerCounting = userDefaults.bool(forKey: UserKey.TimeData.countingKey)
        
        if timerCounting {
            let projectID = userDefaults.string(forKey: UserKey.TimeData.projectKey)
            let taskID = userDefaults.string(forKey: UserKey.TimeData.taskKey)

            if let projectID, let taskID {
                let projectData = projectRepository.fetchByID(try! ObjectId(string: projectID))
                let taskData = taskRepository.fetchByID(try! ObjectId(string: taskID))
                completion(projectData, taskData)
            }
        }
    }
}

// MARK: - ProjectListVC의 CollectionView에서 사용할 메서드
extension ProjectListViewModel {
    
    //indexPath에 따라 projectData를 반환하는 메서드
    func projectDataForIndex(index: Int) -> ProjectTable {
        return projectList.value[index]
    }

    //선택한 셀의 데이터를 UserDefaults에 저장하는 메서드
    func setUserDefaultsWithProjectData(projectData: ProjectTable) {
        userDefaults.set(projectData._id.stringValue, forKey: UserKey.TimeData.projectKey)
    }

    //delete projectData by index (Realm)
    func deleteProjectAtIndex(index: Int) {
        let projectData = projectList.value[index]
        projectRepository.deleteItem(projectData)
        projectList.value = Array(projectRepository.fetch())
    }
}
