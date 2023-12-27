//
//  AddTaskViewModel.swift
//  Timo
//
//  Created by Chaewon on 2023/10/06.
//

import Foundation

class AddTaskViewModel {
    var title = CustomObservable("")
    var isValid = CustomObservable(false)
    
    func checkValidation() {
        if title.value.isEmpty {
            isValid.value = false
        } else {
            isValid.value = true
        }
    }
}
