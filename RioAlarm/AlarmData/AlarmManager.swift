//
//  AlarmManager.swift
//  RioAlarm
//
//  Created by Noah Albrock on 23/11/2025.
//

import Foundation
import SwiftData

class AlarmManager {
    static let shared = AlarmManager()
    
    static let baseURL = "localhost:8080"
    static let alarmsEndpoint = "/alarms"
    
    var modelContext: ModelContext?
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var testAPIAlarms = [
        Alarm(name: "API Alarm 1"),
        Alarm(name: "API Alarm 2")
    ]
    
    func getAlarms() async throws -> [Alarm] {
        // TODO: Get the alarm list from the server
        print("GET")
        return testAPIAlarms
    }
    
    func addAlarm(_ alarm: Alarm) async throws {
        // TODO: Add an alarm to the list
        print("ADD")
        testAPIAlarms.append(alarm)
    }
    
    func editAlarm(_ alarm: Alarm) async throws {
        print("EDIT")
        testAPIAlarms.removeAll { $0.id == alarm.id }
        testAPIAlarms.append(alarm)
    }
    
    func deleteAlarm(withID id: String) async throws {
        print("DELETE")
        testAPIAlarms.removeAll { $0.id == id }
    }
}
