//
//  SettingsViewConfigurator.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import SwiftUI

enum SettingsViewConfigurator {
    static func configureView(
        viewInputs: SettingsConfiguratorInputs
    ) -> some View {
        let settingsViewModel = SettingsViewModel(
            coordinator: viewInputs.coordinator,
            appSettingsManager: viewInputs.appSettingsManager
        )
        let settingsView = SettingsView(
            viewModel: settingsViewModel
        )
        return settingsView
    }
}
