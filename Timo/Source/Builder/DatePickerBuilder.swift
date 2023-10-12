//
//  DatePickerBuilder.swift
//  Timo
//
//  Created by Chaewon on 2023/10/03.
//

import UIKit

extension UIDatePicker {
    static func datePickerBuilder(datePickerMode: UIDatePicker.Mode = .date, datePickerStyle: UIDatePickerStyle = .automatic) -> UIDatePicker {
        let view = UIDatePicker()
        view.datePickerMode = datePickerMode
        view.preferredDatePickerStyle = datePickerStyle
        view.minuteInterval = 5
        return view
    }
}
