//
//  ProjectTable.swift
//  Timo
//
//  Created by Chaewon on 2023/09/30.
//

import Foundation
import RealmSwift

class ProjectTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var deadline: Date?
    @Persisted var color: String?
    @Persisted var done: Bool
    
    //To Many Relationship
    @Persisted var tasks: List<TaskTable>

    convenience init(_id: ObjectId, title: String, memo: String?, deadline: Date?, color: String?, done: Bool) {
        self.init()
        
        self.title = title
        self.memo = memo
        self.deadline = deadline
        self.color = color
        self.done = false
    }
    
}

