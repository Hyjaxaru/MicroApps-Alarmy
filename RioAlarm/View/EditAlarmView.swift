//
//  EditAlarmView.swift
//  RioAlarm
//
//  Created by Noah Albrock on 27/11/2025.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var alarm: Alarm
    var deleteAction: () -> ()
    
    init(for alarm: Alarm, deleteAction: @escaping () -> ()) {
        self.alarm = alarm
        self.deleteAction = deleteAction
    }

    var listBackgroundColor: Color { Color(colorScheme == .dark ? .systemBackground : .secondarySystemBackground) }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.accentColor,
                            listBackgroundColor
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .ignoresSafeArea()
            
            List {
                // MARK: - Time Header
                Section {
                    HStack {
                        Spacer()
                        
                        Text(alarm.date.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 96))
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                        
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
                // MARK: - Settings
                Section {
                    // time
                    DatePicker("Time", selection: $alarm.date, displayedComponents: [.hourAndMinute])
                    
                    // name
                    HStack {
                        Text("Name")
                        
                        Spacer()
                        
                        TextField("Name", text: $alarm.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // enabled
                    Toggle("Enabled", isOn: $alarm.enabled)
                    
                    // days
                    VStack(alignment: .leading) {
                        Text("Days")
                            .badge(alarm.dayDisplay)
                        
                        HStack {
                            ForEach(AlarmDay.all, id: \.rawValue) { day in
                                let index = day.name.index(day.name.startIndex, offsetBy: 0)
                                let selected = alarm.days.contains(day)
                                let color = selected ? Color.accentColor : listBackgroundColor
                                
                                Text(String(day.name[index]))
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(Circle().fill(color))
                                    .foregroundStyle(selected ? color.adaptedTextColor() : .primary)
                                    .fontWeight(selected ? .bold : .regular)
                                    .onTapGesture {
                                        if selected {
                                            alarm.days.removeAll(where: { $0 == day })
                                        } else {
                                            alarm.days.append(day)
                                        }
                                    }
                            }
                        }
                    }
                }
                
                // MARK: - Actions
                Section {
                    Button("Delete", systemImage: "trash", role: .destructive, action: deleteAction)
                } header: {
                    Text("Options")
                } footer: {
                    Text(alarm.id)
                }
            }
            .navigationTitle(alarm.name)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        EditAlarmView(
            for: Alarm(
                id: UUID().uuidString,
                name: "Everyday Alarm",
                date: .now,
                days: AlarmDay.all,
                enabled: true,
            ),
            deleteAction: {}
        )
    }
}
