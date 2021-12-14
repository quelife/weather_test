//
//  DoubleExtension.swift
//  WeatherTest
//
//  Created by que on 15/12/2564 BE.
//

import Foundation

extension Double {
    func getTime() -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func getDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
