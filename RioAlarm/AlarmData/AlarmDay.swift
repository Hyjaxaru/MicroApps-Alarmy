//
//  AlarmDay.swift
//  RioAlarm
//
//  Created by Noah Albrock on 23/11/2025.
//

import Foundation

enum AlarmDay: String, Codable, Identifiable {
    case monday = "mon"
    case tuesday = "tue"
    case wedensday = "wed"
    case thursday = "thu"
    case friday = "fri"
    case saturday = "sat"
    case sunday = "sun"
    
    var id: String { rawValue }
    var name: String { rawValue.capitalized }
}

extension AlarmDay {
    static let all: [AlarmDay] = [.monday, .tuesday, .wedensday, .thursday, .friday, .saturday, .sunday]
    static let weekdays: [AlarmDay] = [.monday, .tuesday, .wedensday, .thursday, .friday]
    static let weekends: [AlarmDay] = [.saturday, .sunday]
}
