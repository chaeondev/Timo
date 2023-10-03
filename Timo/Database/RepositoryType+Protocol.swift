//
//  RepositoryType.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import Foundation
import RealmSwift


protocol RepositoryType {
    
    associatedtype T: Object
    
    func checkRealmURL()
    func createItem(_ item: T)
    func fetch() -> Results<T>
    func fetchByID(_ id: ObjectId) -> T?
    func updateItem(_ item: T)
    func deleteItem(_ item: T)
}
