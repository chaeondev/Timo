//
//  TaskTable.swift
//  Timo
//
//  Created by Chaewon on 2023/09/30.
//

import Foundation
import RealmSwift

class TaskTable: Object {
    
    //Inverse Relationship Property (LinkingObjects)
    @Persisted(originProperty: "tasks") var mainProject: LinkingObjects<ProjectTable>
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var savedDate: Date
    @Persisted var date: Date?
    @Persisted var expectedTime: Int?
    @Persisted var completed: Bool
    
    @Persisted var realTime: Int?
    @Persisted var timerStart: Date?
    @Persisted var timerStop: Date?
    @Persisted var timerCounting: Bool
    
    @Persisted var subTasks: List<SubTaskTable>
    
    convenience init(title: String, savedDate: Date, date: Date?, expectedTime: Int?, realTime: Int?, completed: Bool = false, timerStart: Date?, timerStop: Date?, timerCounting: Bool = false) {
        self.init()
        
        self.title = title
        self.savedDate = savedDate
        self.date = date
        self.expectedTime = expectedTime
        self.realTime = realTime
        self.completed = completed
        self.timerStart = timerStart
        self.timerStop = timerStop
        self.timerCounting = timerCounting
    }

}
