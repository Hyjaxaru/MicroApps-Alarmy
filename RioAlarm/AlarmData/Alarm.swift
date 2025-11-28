//
//  Alarm.swift
//  RioAlarm
//
//  Created by Noah Albrock on 23/11/2025.
//

import Foundation
import SwiftData

@Model
class Alarm: Codable, Identifiable {
    var id: String
    var name: String
    var dateTs: Int = 0
    var days: [AlarmDay]
    var enabled: Bool
    
    var date: Date {
        get {
            return Date(timeIntervalSince1970: TimeInterval(dateTs))
        }
        set(newDate) {
            dateTs = Int(newDate.timeIntervalSince1970)
        }
    }
    
    var dayDisplay: String {
        let on: [Bool] = [
            days.contains(.monday),
            days.contains(.tuesday),
            days.contains(.wedensday),
            days.contains(.thursday),
            days.contains(.friday),
            days.contains(.saturday),
            days.contains(.sunday)
        ]
        
        // every day
        if Set(days).isSuperset(of: Set(AlarmDay.all)) { return "Every Day" }
        
        // week days and weekends
        else if  on[0] &&  on[1] &&  on[2] &&  on[3] &&  on[4] && !on[5] && !on[6] { return "Week Days" }
        else if !on[0] && !on[1] && !on[2] && !on[3] && !on[4] &&  on[5] &&  on[6] { return "Weekends" }
        
        // no days
        else if days.isEmpty { return "None" }
        
        // any days
        //else { return days.map(\.rawValue.localizedCapitalized).joined(separator: ", ") }
        else { return "Custom" }
    }
    
    // MARK: - Initialisers
    init(id: String, name: String, date: Date, days: [AlarmDay], enabled: Bool) {
        self.id = id
        self.name = name
        self.days = days
        self.enabled = enabled
        self.date = date
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        dateTs = try values.decode(Int.self, forKey: .dateTs)
        days = try values.decodeIfPresent(Array<AlarmDay>.self, forKey: .days) ?? []
        enabled = try values.decode(Bool.self, forKey: .enabled)
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name
        case dateTs = "date"
        case days, enabled
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dateTs, forKey: .dateTs)
        try container.encode(days, forKey: .days)
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(dateTs)
        hasher.combine(days)
        hasher.combine(enabled)
    }
}

func == (lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.id == rhs.id
}

// MARK: - Static
extension Alarm {
    static let example: Alarm = .init(
        id: UUID().uuidString,
        name: "Example",
        date: Date(),
        days: AlarmDay.all,
        enabled: true
    )
}
