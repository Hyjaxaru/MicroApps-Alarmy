//
//  EditApiKeySheet.swift
//  RioAlarm
//
//  Created by Noah Albrock on 28/11/2025.
//

import SwiftUI
import KeychainSwift

struct EditApiKeySheet: View {
    @Binding var isPresented: Bool
    
    @State private var tempKeyText: String
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        
        let keychain = KeychainSwift()
        self.tempKeyText = keychain.get("apikey") ?? ""
    }
    
    func pasteFromClipboard() {
        self.tempKeyText = UIPasteboard.general.string!
    }
    
    func cancelAction() {
        self.isPresented.toggle()
    }
    
    func confirmAction() {
        let keychain = KeychainSwift()
        keychain.set(tempKeyText, forKey: "apikey")
        
        self.isPresented.toggle()
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SecureField("Super Secret Key", text: $tempKeyText)
                } footer: {
                    Text("This key will be stored securely in your iCloud Keychain")
                }
                
                Section {
                    Button("Paste from Clipboard", action: pasteFromClipboard)
                        .disabled(UIPasteboard.general.string == nil)
                }
            }
            .navigationTitle("Edit Api Key")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if #available(iOS 26.0, *) {
                        Button("Cancel", systemImage: "xmark", role: .cancel, action: cancelAction)
                    } else {
                        Button("Cancel", action: cancelAction)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if #available(iOS 26.0, *) {
                        Button("Done", systemImage: "checkmark", role: .confirm, action: confirmAction)
                    } else {
                        Button("Done", action: cancelAction)
                    }
                }
            }
        }
    }
}

#Preview {
    EditApiKeySheet(isPresented: .constant(true))
}
