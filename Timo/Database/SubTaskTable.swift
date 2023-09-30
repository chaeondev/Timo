//
//  SubTaskTable.swift
//  Timo
//
//  Created by Chaewon on 2023/09/30.
//

import Foundation
import RealmSwift

class SubTaskTable: Object {
    
    @Persisted(originProperty: "subTasks") var mainProject: LinkingObjects<TaskTable>
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var completed: Bool
    
    convenience init(title: String, completed: Bool) {
        self.init()
        
        self.title = title
        self.completed = false
    }

}
