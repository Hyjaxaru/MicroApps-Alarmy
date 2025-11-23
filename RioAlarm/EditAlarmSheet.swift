//
//  EditAlarmSheet.swift
//  RioAlarm
//
//  Created by Noah Albrock on 23/11/2025.
//

import SwiftUI

struct EditAlarmSheet: View {
    @Binding var isPresented: Bool
    @Binding var alarm: Alarm
    
    @State private var tempAlarm: Alarm
    
    init(isPresented: Binding<Bool>, alarm: Binding<Alarm>) {
        self._isPresented = isPresented
        self._alarm = alarm
        self.tempAlarm = alarm.wrappedValue
    }
    
    func cancelAction() {
        isPresented.toggle()
    }
    
    func confirmAction() {
        alarm = tempAlarm
        isPresented.toggle()
    }
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Time Selection
                Section {
                    DatePicker(
                        "",
                        selection: $tempAlarm.date,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                }
                .listRowBackground(Color.clear)
                
                // MARK: - Settings
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Name", text: $tempAlarm.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Toggle("Enabled", isOn: $tempAlarm.enabled)
                } footer: {
                    Text(alarm.id)
                }
            }
            // MARK: - Toolbar
            .navigationTitle("Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", systemImage: "xmark", role: .cancel, action: cancelAction)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", systemImage: "checkmark", role: .confirm, action: confirmAction)
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: cancelAction)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: confirmAction)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    EditAlarmSheet(
        isPresented: .constant(true),
        alarm: .constant(Alarm.example)
    )
}
