//
//  ProjectDetailViewModel.swift
//  Timo
//
//  Created by Chaewon on 2023/10/26.
//

import Foundation
import RealmSwift

class ProjectDetailViewModel {
    
    private let projectRepository = ProjectTableRepository()
    private let taskRepository = TaskTableRepository()
    
    private let userDefaults = UserDefaults.standard
    
    var projectData: CustomObservable<ProjectTable> = CustomObservable(ProjectTable())
    var tasks: CustomObservable<[TaskTable]> = CustomObservable([])
    
    func fetchProjectData(projectData: ProjectTable) {
        self.projectData.value = projectData
    }
    
    func getProjectDateRange() -> String {
        guard let startDate = projectData.value.startDate,
              let endDate = projectData.value.endDate else { return "" }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yy.MM.dd"
        
        return "\(dateformatter.string(from: startDate)) - \(dateformatter.string(from: endDate))"
    }
    
    func isProjectDone() -> Bool {
        return self.projectData.value.done
    }
    
    func deleteProjectData() {
        projectRepository.deleteItem(projectData.value)
    }

    func toggleProjectIsDone() {
        projectRepository.updateItem {
            projectData.value.done.toggle()
        }
    }
    
}

extension ProjectDetailViewModel {
    
    func fetchTaskData() {
        let fetchedTasks = projectData.value.tasks.sorted(byKeyPath: "savedDate")
        self.tasks.value = Array(fetchedTasks)
    }
    
    func updateTaskDataIsDoneByIndex(index: Int) {
        let data = self.tasks.value[index]
        taskRepository.updateItem {
            data.completed.toggle()
        }
        fetchTaskData()
    }
    
    func deleteTaskDataAtIndex(index: Int) {
        let data = self.tasks.value[index]
        taskRepository.deleteItem(data)
        fetchTaskData()
    }
    
    func setUserDefaultsWithTaskData(_ task: TaskTable) {
        userDefaults.set(task._id.stringValue, forKey: UserKey.TimeData.taskKey)
    }
}

extension ProjectDetailViewModel {
    func countTotalTaskActivity() -> (Int, Int) {
        let doneTaskCount = self.tasks.value.filter { $0.completed == true }.count
        let totalTaskCount = self.tasks.value.count
        
        return (doneTaskCount, totalTaskCount)
        
    }
    func setTotalWorkingHour() -> (Int, Int, Int) {
        var totalHour = 0
        
        self.tasks.value.forEach {
            totalHour += ($0.realTime ?? 0)
        }
        
        let hours = totalHour / 3600
        let minutes = totalHour / 60 % 60
        let seconds = totalHour % 60
        
        return (hours, minutes, seconds)
    }
}
