//
//  AddProjectViewModel.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import Foundation

class AddProjectViewModel {
    
    var title = CustomObservable("")
    var startDate: Date?
    var endDate: Date?
    var color: String?

    var isValid = CustomObservable(false)
    var projectData: CustomObservable<ProjectTable?> = CustomObservable(nil)
    
    private let projectRepository = ProjectTableRepository()
    
    func updateTitle(_ newTitle: String) {
        title.value = newTitle
        checkValidation()
    }
    
    func updateStartDate(_ newStartDate: Date, completion: @escaping (Date) -> Void ) {
        startDate = newStartDate
        if let startDate {
            completion(startDate)
        }
    }
    
    func updateEndDate(_ newEndDate: Date, completion: @escaping(Date) -> Void ) {
        endDate = newEndDate
        if let endDate {
            completion(endDate)
        }
    }
    
    func updateColor(_ newColor: String) {
        color = newColor
    }
    
    func checkValidation() {
        if title.value.isEmpty {
            isValid.value = false
        } else {
            isValid.value = true
        }
    }
}

extension AddProjectViewModel {
    //navigation title setting
    func setTitle(menuType: ProjectMenuType) -> String {
        switch menuType {
        case .add:
            return "navigation_create_title".localized
        case .edit:
            return "navigation_edit_title".localized
        }
    }
    
    //navigation save button clicked
    func saveProject(menuType: ProjectMenuType, saveCompletion: @escaping () -> Void) {
        
        switch menuType {
        case .add:
            createProjectItem()
        case .edit:
            updateProjectItem()
        }
        saveCompletion()

    }
    
    func createProjectItem() {
        let projectItem = ProjectTable(title: title.value, savedDate: Date(), startDate: startDate ?? Date(), endDate: endDate ?? Date(), color: color, done: false)
        projectRepository.createItem(projectItem)
    }
    
    func updateProjectItem() {
        guard let projectData = projectData.value else { return }
        projectRepository.updateItem {
            projectData.title = title.value
            projectData.startDate = startDate
            projectData.endDate = endDate
            projectData.color = color
        }
    }
        
}

extension AddProjectViewModel {
    func setProjectData(_ projectData: ProjectTable?) {
        self.projectData.value = projectData
    }
    
    func setupProjectDataInEditView() {
        if let projectData = projectData.value {
            title.value = projectData.title
            startDate = projectData.startDate
            endDate = projectData.endDate
            color = projectData.color
            checkValidation()
        }
    }
}
