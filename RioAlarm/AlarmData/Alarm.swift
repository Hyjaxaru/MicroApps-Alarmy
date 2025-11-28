//
//  Alarm.swift
//  RioAlarm
//
//  Created by Noah Albrock on 23/11/2025.
//

import Foundation

class Alarm: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var dateTs: Int = 0
    var days: [AlarmDay]
    var enabled: Bool
    var willRepeat: Bool
    
    // MARK: - Getters
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
    init(name: String, date: Date = .now, days: [AlarmDay] = AlarmDay.all, enabled: Bool = true, willRepeat: Bool = true) {
        self.id = UUID().uuidString
        self.name = name
        self.days = days
        self.enabled = enabled
        self.willRepeat = willRepeat
        self.date = date
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.dateTs = try values.decode(Int.self, forKey: .dateTs)
        self.days = try values.decode([AlarmDay].self, forKey: .days)
        self.enabled = try values.decode(Bool.self, forKey: .enabled)
        self.willRepeat = try values.decode(Bool.self, forKey: .withRepeat)
        
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name
        case dateTs = "date"
        case days, enabled
        case withRepeat = "repeat"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dateTs, forKey: .dateTs)
        try container.encode(days, forKey: .days)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(willRepeat, forKey: .withRepeat)
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(dateTs)
        hasher.combine(days)
        hasher.combine(enabled)
        hasher.combine(willRepeat)
    }
}

func == (lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.date == rhs.date
    && lhs.days == rhs.days
    && lhs.enabled == rhs.enabled
    && lhs.willRepeat == rhs.willRepeat
}

// MARK: - Static
extension Alarm {
    static let new: Alarm = .init(name: "New Alarm")
}
