//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/25.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
