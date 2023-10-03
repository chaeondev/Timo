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
    @Persisted var date: Date?
    @Persisted var expectedTime: Int?
    @Persisted var realTime: Int?
    @Persisted var completed: Bool
    
    @Persisted var subTasks: List<SubTaskTable>
    
    convenience init(title: String, date: Date?, expectedTime: Int?, realTime: Int?, completed: Bool) {
        self.init()
        
        self.title = title
        self.date = date
        self.expectedTime = expectedTime
        self.realTime = realTime
        self.completed = false
    }

}
