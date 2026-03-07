//
//  MenuViewConfigurator.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import SwiftUI

enum MenuViewConfigurator {
    static func configureView(
        inputs: MenuViewConfiguratorInputs
    ) -> some View {
        let menuViewModel = MenuViewModel(
            coordinator: inputs.coordinator,
            hapticFeedbackManager: inputs.hapticFeedbackManager,
            appSettingsManager: inputs.appSettingsManager,
            gameSettingsManager: inputs.gameSettingsManager,
            gameHistoryManager: inputs.gameHistoryManager
        )
        
        let menuView = MenuView(viewModel: menuViewModel)
        return menuView
    }
}
