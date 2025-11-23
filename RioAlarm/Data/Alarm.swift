//
//  Alarm.swift
//  RioAlarm
//
//  Created by Noah Albrock on 23/11/2025.
//

import Foundation

struct Alarm: Codable, Identifiable, Hashable, Sendable, Equatable {
    var id: String
    var name: String
    var date: Date
    var enabled: Bool
}

extension Alarm {
    static let example: Self = .init(id: UUID().uuidString, name: "Example", date: Date(), enabled: true)
}

struct UIAlarm: Codable, Identifiable, Hashable, Sendable, Equatable {
    var alarm: Alarm
    var isEditSheetPresented: Bool = false
    
    var id: String { alarm.id }
    var name: String { alarm.name }
    var date: Date { alarm.date }
    var enabled: Bool { alarm.enabled }
    
    init(id: String, name: String, date: Date, enabled: Bool) {
        alarm = .init(id: id, name: name, date: date, enabled: enabled)
    }
}
