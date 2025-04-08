import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    
    private var isDarkModeOn: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Game Settings")) {
                    Toggle("Sound Effects", isOn: $soundEnabled)
                        .tint(.blue)
                    
                    Toggle("Haptic Feedback", isOn: $hapticEnabled)
                        .tint(.blue)
                    
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                        .tint(.blue)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Mikheil Muchaidze")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("© 2025 CoopSweeper")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Section(header: Text("Links")) {
                    Link(destination: URL(string: "https://www.example.com/privacy")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Link(destination: URL(string: "https://www.example.com/terms")!) {
                        HStack {
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Link(destination: URL(string: "https://www.example.com/support")!) {
                        HStack {
                            Text("Support")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Credits")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Icons: SF Symbols by Apple")
                        Text("Sounds: FreeSound.org")
                        Text("Special thanks to all beta testers!")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
} 