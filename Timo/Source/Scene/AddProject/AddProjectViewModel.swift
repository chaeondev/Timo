//
//  AddProjectViewModel.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import Foundation

class AddProjectViewModel {
    var title = Observable("")
    var isValid = Observable(false)
    
    func checkValidation() {
        if title.value.isEmpty {
            isValid.value = false
        } else {
            isValid.value = true
        }
    }
}
