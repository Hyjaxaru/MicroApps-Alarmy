//
//  AppConfigSheet.swift
//  RioAlarm
//
//  Created by Noah Albrock on 27/11/2025.
//

import SwiftUI

struct AppConfigSheet: View {
    @Binding var isPresented: Bool
    
    @AppStorage("apiEndpointGetAlarms") private var apiEndpointGetAlarms: String = ""
    @AppStorage("apiEndpointPostAlarm") private var apiEndpointPostAlarm: String = ""
    
    @State private var isEditKeySheetPresented: Bool = false
    
    func confirmAction() { isPresented.toggle() }
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - App Header
                Section {
                    HStack {
                        Image(.appIconSymbol)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        
                        Spacer()
                            .frame(width: 24)
                            
                        VStack(alignment: .leading) {
                            Text("Alarmy")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Alarm clock configurator")
                            
                            Text("CMP101/104 - Abertay 2025")
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.accentColor.gradient)
                    .foregroundStyle(.white)
                }
                .listRowInsets(EdgeInsets())
                
                // MARK: - API Auth
                Section {
                    Button("Edit API Key") { isEditKeySheetPresented.toggle() }
                        .sheet(isPresented: $isEditKeySheetPresented) {
                            EditApiKeySheet(isPresented: $isEditKeySheetPresented)
                                .presentationDetents([.medium, .large])
                        }
                } header: {
                    Text("API Auth")
                } footer: {
                    Text("This will be stored securely in your iCloud Keychain")
                }
                
                // MARK: - Links
                Section {
                    Link(destination: URL(string: "https://github.com/Hyjaxaru/MicroApps-Alarmy")!) {
                        Text("Source").badge("Github.com")
                    }
                    
                    Link(destination: URL(string: "https://riothe.dev")!) {
                        Text("Rio's Portfolio").badge("riothe.dev")
                    }
                    
                    Link(destination: URL(string: "https://www.hyjaxaru.dev")!) {
                        Text("My Portfolio").badge("hyjaxaru.dev")
                    }
                } header: {
                    Text("About")
                } footer: {
                    VStack(alignment: .leading) {
                        let year = Calendar.current.component(.year, from: Date())
                        HStack(spacing: 0) {
                            Text("Copyright © \(String(year)) Noah Albrock  ")
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                            
                            Text("  Made with ")
                            
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.pink.gradient)
                                .font(.system(size: 12))
                        }
                        
                        Spacer()
                        
                        Text("This project is designed to be seperate from Rio Wrenn's work in CMP101/104, and is not ment to be assessed alongside it.")
                    }
                }
            }
            .navigationTitle("About Alarmy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if #available(iOS 26.0, *) {
                        Button("Done", systemImage: "checkmark", role: .confirm, action: confirmAction)
                    } else {
                        Button("Done", action: confirmAction)
                    }
                }
            }
        }
    }
}

// MARK: - TextField List Row
private struct URLTextFieldListRow: View {
    let title: String
    let hint: String
    @Binding var text: String
    
    init(_ title: String, hint: String? = nil, text: Binding<String>) {
        self.title = title
        self.hint = hint ?? title
        self._text = text
    }
    
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            TextField(hint, text: $text)
                .multilineTextAlignment(.trailing)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.URL)
        }
    }
}

#Preview {
    AppConfigSheet(isPresented: .constant(true))
}
