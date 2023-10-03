//
//  DatePickerBuilder.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import UIKit

extension UIDatePicker {
    static func datePickerBuilder() -> UIDatePicker {
        let view = UIDatePicker()
        view.datePickerMode = .date
        return view
    }
}
