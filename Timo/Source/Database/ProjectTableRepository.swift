//
//  ProjectTableRepository.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import Foundation
import RealmSwift

class ProjectTableRepository: RepositoryType {
    
    typealias T = ProjectTable

    // TODO: failable init 공부하기
    private let realm = try! Realm()
    
    
    func checkRealmURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }
    
    func createItem(_ item: ProjectTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error) // TODO: 로그, alert -> update, delete 다 하기
        }
    }
    
    // 등록순 정렬이 default
    func fetch() -> RealmSwift.Results<ProjectTable> {
        let data = realm.objects(ProjectTable.self).sorted(byKeyPath: "savedDate", ascending: false)
        return data
    }
    
    func fetchByID(_ id: RealmSwift.ObjectId) -> ProjectTable? {
        let data = realm.object(ofType: ProjectTable.self, forPrimaryKey: id)
        return data
    }
    
    func upsertItem(_ item: ProjectTable) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
    
    
    func deleteItem(_ item: ProjectTable) {
        do {
            try realm.write {
                // TODO: subTasks 추가시 이 부분까지 고려하기
                realm.delete(item.tasks)
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}
