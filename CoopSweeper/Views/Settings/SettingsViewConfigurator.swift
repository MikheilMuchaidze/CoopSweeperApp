//
//  SettingsViewConfigurator.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import SwiftUI

enum SettingsViewConfigurator {
    static func configureView(
        inputs: SettingsConfiguratorInputs
    ) -> some View {
        let settingsViewModel = SettingsViewModel(
            coordinator: inputs.coordinator,
            appSettingsManager: inputs.appSettingsManager
        )
        let settingsView = SettingsView(
            viewModel: settingsViewModel
        )
        return settingsView
    }
}
