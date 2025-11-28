//
//  EditAlarmView.swift
//  RioAlarm
//
//  Created by Noah Albrock on 27/11/2025.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var alarm: Alarm
    var editAction: () -> ()
    var deleteAction: () -> ()
    
    @State private var tempAlarm: Alarm
    
    init(
        for alarm: Alarm,
        editAction: @escaping () -> (),
        deleteAction: @escaping () -> ()
    ) {
        self.alarm = alarm
        self.tempAlarm = alarm
        
        self.editAction = editAction
        self.deleteAction = deleteAction
    }

    var listBackgroundColor: Color { Color(colorScheme == .dark ? .systemBackground : .secondarySystemBackground) }
    
    @State private var test: Set<AlarmDay> = []
    
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
                    DatePicker("Time", selection: $tempAlarm.date, displayedComponents: [.hourAndMinute])
                    
                    // name
                    HStack {
                        Text("Name")
                        
                        Spacer()
                        
                        TextField("Name", text: $tempAlarm.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // enabled
                    Toggle("Enabled", isOn: $tempAlarm.enabled)
                    
                    // days
                    VStack(alignment: .leading) {
                        Text("Days")
                            .badge(tempAlarm.dayDisplay)
                        
                        HStack {
                            ForEach(AlarmDay.all, id: \.rawValue) { day in
                                let index = day.name.index(day.name.startIndex, offsetBy: 0)
                                let selected = tempAlarm.days.contains(day)
                                let color = selected ? Color.accentColor : listBackgroundColor
                                
                                Text(String(day.name[index]))
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(Circle().fill(color))
                                    .foregroundStyle(selected ? color.adaptedTextColor() : .primary)
                                    .fontWeight(selected ? .bold : .regular)
                                    .onTapGesture {
                                        if selected {
                                            tempAlarm.days.removeAll(where: { $0 == day })
                                        } else {
                                            tempAlarm.days.append(day)
                                        }
                                    }
                            }
                        }
                    }
                }
                
                // MARK: - Danger Zone
                Section {
                    Button("Delete", systemImage: "trash", role: .destructive, action: deleteAction)
                        .foregroundStyle(.red)
                } header: {
                    Text("Danger Zone")
                } footer: {
                    Text(tempAlarm.id)
                }
            }
            .navigationTitle(alarm.name)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if tempAlarm != alarm {
                        if #available(iOS 26.0, *) {
                            Button("Done", systemImage: "checkmark", role: .confirm, action: editAction)
                        } else {
                            Button("Done", action: editAction)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete", systemImage: "trash", role: .destructive, action: deleteAction)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        EditAlarmView(
            for: Alarm.new,
            editAction: {},
            deleteAction: {}
        )
    }
}
