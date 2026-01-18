import SwiftUI

struct SettingsView: View {
    // MARK: - ViewModel
    
    @State private var viewModel: SettingsViewModelProtocol
    
    // MARK: - Init
    
    init(
        viewModel: SettingsViewModelProtocol
    ) {
        self.viewModel = viewModel
    }

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
                    Button(
                        "Done",
                        action: viewModel.dismissView
                    )
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
                viewModel.getSoundEffectsSetting()
            }, set: { newValueForSoundSetting in
                viewModel.updateSoundEffectSetting(with: newValueForSoundSetting)
            }))

            Toggle("Haptic Feedback", isOn: .init(get: {
                viewModel.getVibrationSetting()
            }, set: { newValueForVibrationSetting in
                viewModel.updateVibrationSetting(with: newValueForVibrationSetting)
            }))

            Picker("Dark Mode", selection: .init(get: {
                viewModel.getCurrentThemeSetting()
            }, set: { newValueForDarkModeSetting in
                viewModel.updateCurrentThemeSetting(with: newValueForDarkModeSetting)
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
            Button(action: viewModel.navigateToPrivacyPolices) {
                HStack {
                    Text("Privacy Policy")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                }
                .foregroundColor(.blue)
            }
            
            Button(action: viewModel.navigateToTermsAndConditions) {
                HStack {
                    Text("Terms of Service")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                }
                .foregroundColor(.blue)
            }
            
            Button(action: viewModel.navigateToSupport) {
                HStack {
                    Text("Support")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                }
                .foregroundColor(.blue)
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
    let viewModel = SettingsViewModel(
        coordinator: Coordinator(),
        appSettingsManager: AppSettingsManager()
    )
    SettingsView(
        viewModel: viewModel
    )
}
