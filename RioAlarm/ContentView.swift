//
//  ContentView.swift
//  RioAlarm
//
//  Created by Noah Albrock on 23/11/2025.
//

import SwiftUI

struct ContentView: View {    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State private var viewModel = ViewModel()
    
    func addAlarm() {
        withAnimation {
            let alarm = Alarm.new
            viewModel.alarms.append(alarm)
            viewModel.selectedAlarm = alarm
        }
    }
    
    var body: some View {
        NavigationSplitView {
            ZStack {
                List(viewModel.alarms, selection: $viewModel.selectedAlarm) { alarm in
                    NavigationLink(value: alarm) {
                        VStack(alignment: .leading) {
                            Text(alarm.date.formatted(date: .omitted, time: .shortened))
                                .font(.system(size: 72))
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                            
                            HStack {
                                Text(alarm.name)
                                    .lineLimit(1)
                                
                                Text("-")
                                    .foregroundStyle(.secondary)
                                
                                Text(alarm.dayDisplay)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                if viewModel.alarms.isEmpty {
                    ContentUnavailableView {
                        Label("No Alarms", systemImage: "alarm")
                    } description: {
                        Text("You don't have any alarms set up.")
                        
                        Button("Create new Alarm", systemImage: "plus", action: addAlarm)
                    }
                }
            }
            .navigationTitle("Alarms")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("settings", systemImage: "gear") {
                        viewModel.isAppConfigSheetPresented.toggle()
                    }
                    .sheet(isPresented: $viewModel.isAppConfigSheetPresented) {
                        AppConfigSheet(isPresented: $viewModel.isAppConfigSheetPresented)
                    }
                }
                
                if horizontalSizeClass == .compact {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", systemImage: "plus", action: addAlarm)
                    }
                }
            }
        } detail: {
            if viewModel.selectedAlarm != nil {
                EditAlarmView(
                    for: viewModel.selectedAlarm!,
                    editAction: {},
                    deleteAction: {}
                )
                .toolbar {
                    if horizontalSizeClass != .compact {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add", systemImage: "plus", action: addAlarm)
                        }
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("Alarmy", systemImage: "alarm")
                } description: {
                    Text("Select an alarm to edit it.")
//                    
//                    Button("Create new Alarm", systemImage: "plus", action: addAlarm)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", systemImage: "plus", action: addAlarm)
                    }
                }
            }
        }
    }
}

// MARK: - View Model
extension ContentView {
    @Observable
    class ViewModel {
        var alarms: [Alarm] = []
        var selectedAlarm: Alarm?
        
        var isAppConfigSheetPresented: Bool = false
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
