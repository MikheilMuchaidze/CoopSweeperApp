import SwiftUI

struct SettingsView: View {
    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appSettingsManager) private var appSettingsManager

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                gameSettingsSection
                aboutSection
                linksSection
                creditsSection
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

// MARK: - Body Components

extension SettingsView {
    private var gameSettingsSection: some View {
        Section(header: Text("Game Settings")) {
            Toggle("Sound Effects", isOn: .init(get: {
                appSettingsManager.soundEnabled
            }, set: { newValueForSoundSetting in
                appSettingsManager.updateSettings(with: .sound(isOn: newValueForSoundSetting))
            }))

            Toggle("Haptic Feedback", isOn: .init(get: {
                appSettingsManager.vibrationEnabled
            }, set: { newValueForVibrationSetting in
                appSettingsManager.updateSettings(with: .vibrationEnabled(isOn: newValueForVibrationSetting))
            }))

            Picker("Dark Mode", selection: .init(get: {
                appSettingsManager.theme
            }, set: { newValueForDarkModeSetting in
                appSettingsManager.updateSettings(with: .theme(type: newValueForDarkModeSetting))
            })) {
                ForEach(AppTheme.allCases, id: \.self) { appTheme in
                    Text(appTheme.rawValue)
                        .tag(appTheme)
                }
            }
            .tint(.blue)
        }
    }

    private var aboutSection: some View {
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
    }

    private var linksSection: some View {
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
    }

    private var creditsSection: some View {
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
}

// MARK: - Preview

#Preview {
    SettingsView()
}
