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
    @Persisted var savedDate: Date
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var color: String?
    @Persisted var done: Bool
    
    //To Many Relationship
    @Persisted var tasks: List<TaskTable>

    convenience init(title: String, savedDate: Date, startDate: Date?, endDate: Date?, color: String?, done: Bool) {
        self.init()
        
        self.title = title
        self.savedDate = savedDate
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
        self.done = false
    }
    
}

