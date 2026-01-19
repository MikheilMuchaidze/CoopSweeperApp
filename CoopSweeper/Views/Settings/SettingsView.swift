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
            AppConstants.mainBackgroundColor
                .overlay(content: content)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(
                            "Done",
                            action: viewModel.dismissView
                        )
                        .buttonStyle(.glassProminent)
                        .tint(Color.brown)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Body Components

extension SettingsView {
    private func content() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                SettingsCard(title: "Game Settings", content: gameSettingsSection)
                SettingsCard(title: "About", content: aboutSection)
                SettingsCard(title: "Links", content: linksSection)
                creditsSection()
//                SettingsCard(title: "Credits", content: creditsSection)
            }
        }
    }
    
    private func gameSettingsSection() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            SettingsRow(title: "Sound Effects") {
                Toggle("", isOn: .init(
                    get: viewModel.getSoundEffectsSetting,
                    set: viewModel.updateSoundEffectSetting
                ))
                .labelsHidden()
            }

            SettingsRow(title: "Haptic Feedback") {
                Toggle("", isOn: .init(
                    get: viewModel.getVibrationSetting,
                    set: viewModel.updateVibrationSetting
                ))
                .labelsHidden()
            }

            SettingsRow(title: "Dark Mode") {
                Picker("", selection: .init(
                    get: viewModel.getCurrentThemeSetting,
                    set: viewModel.updateCurrentThemeSetting
                )) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Text(theme.rawValue)
                            .tag(theme)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color(red: 0.3, green: 0.7, blue: 0.9))
            }
        }
    }

    private func aboutSection() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            SettingsRow(title: "Version") {
                Text("1.0.0")
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 0.9))
            }
            
            SettingsRow(title: "Developer") {
                Text("Mikheil Muchaidze")
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 0.9))
            }
            
            HStack {
                Text("© 2025 CoopSweeper")
                    .foregroundColor(.white)
                Spacer()
            }
            .font(.caption)
            .padding()
        }
    }

    private func linksSection() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            SettingsRow(
                title: "Privacy Policy"
            ) {
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 0.9))
                }
            }
            .onTapGesture(perform: viewModel.navigateToPrivacyPolices)
            
            SettingsRow(
                title: "Terms of Service"
            ) {
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 0.9))
                }
            }
            .onTapGesture(perform: viewModel.navigateToTermsAndConditions)
            
            SettingsRow(
                title: "Support"
            ) {
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 0.9))
                }
            }
            .onTapGesture(perform: viewModel.navigateToSupport)
        }
    }

    private func creditsSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Credits")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)

            HStack(spacing: .zero) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Icons: SF Symbols by Apple")
                    Text("Sounds: FreeSound.org")
                    Text("Special thanks to all beta testers!")
                }
                .padding()
                .font(.caption)
                .foregroundColor(.white)
                
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.5))
            )
        }
        .padding(.horizontal, 20)
    }
}

private struct SettingsCard<Content: View>: View {
    // MARK: - Private Properties
    
    private let title: String
    private let content: Content
    
    // MARK: - Init
    
    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.5))
            )
        }
        .padding(.horizontal, 16)
    }
}

private struct SettingsRow<RightView: View>: View {
    // MARK: - Private Properties
    
    private let title: String
    private let titleColor: Color?
    private let right: RightView
    
    // MARK: - Init
    
    init(
        title: String,
        titleColor: Color? = .white,
        @ViewBuilder right: () -> RightView
    ) {
        self.title = title
        self.titleColor = titleColor
        self.right = right()
    }
    
    // MARK: - Body

    var body: some View {
        HStack {
            Text(title)
                .ifTrue(titleColor) { view, titleColor in
                    view
                        .foregroundStyle(titleColor)
                }
            Spacer()
            right
        }
        .padding()
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.leading)
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
