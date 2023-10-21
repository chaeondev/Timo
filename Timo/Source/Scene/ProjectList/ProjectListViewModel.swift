//
//  ProjectListViewModel.swift
//  Timo
//
//  Created by Chaewon on 2023/10/20.
//

import Foundation
import RealmSwift

class ProjectListViewModel {
    private let projectRepository = ProjectTableRepository()
    
    var projectList: CustomObservable<[ProjectTable]> = CustomObservable([])
    
    
    func fetchData() {
        self.projectList.value = Array(projectRepository.fetch())
    }
    
    func fetchDataByIndex(index: Int) -> [ProjectTable] {
        switch index {
        case 0:
            return Array(projectRepository.fetch())
        case 1:
            return Array(projectRepository.fetch().where { $0.done == false })
        case 2:
            return Array(projectRepository.fetch().where { $0.done == true })
        default:
            return Array(projectRepository.fetch())
        }
    }
    
    
    
}
