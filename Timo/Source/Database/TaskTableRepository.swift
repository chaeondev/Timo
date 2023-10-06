//
//  TaskTableRepository.swift
//  Timo
//
//  Created by Chaewon on 2023/10/06.
//

import Foundation
import RealmSwift

class TaskTableRepository: RepositoryType {
    
    typealias T = TaskTable
    
    private let realm = try! Realm()
    
    func checkRealmURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }
    
    func createItem(_ item: TaskTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error) // TODO: 로그, alert -> update, delete 다 하기
        }
    }
    
    func createItem(_ item: TaskTable, project: ProjectTable) {
        do {
            try realm.write {
                realm.add(item)
                project.tasks.append(item)
            }
        } catch {
            print(error) // TODO: 로그, alert -> update, delete 다 하기
        }
    }
    
    func fetch() -> RealmSwift.Results<TaskTable> {
        let data = realm.objects(TaskTable.self).sorted(byKeyPath: "savedDate", ascending: true)
        return data
    }
    
    func fetchByID(_ id: RealmSwift.ObjectId) -> TaskTable? {
        let data = realm.object(ofType: TaskTable.self, forPrimaryKey: id)
        return data
    }
    
    func upsertItem(_ item: TaskTable) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: TaskTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    
}
