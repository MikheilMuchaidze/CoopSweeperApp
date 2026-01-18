//
//  MenuViewConfigurator.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import SwiftUI

enum MenuViewConfigurator {
    static func configureView(
        coordinator: any CoordinatorProtocol
    ) -> some View {
        let menuViewModel = MenuViewModel(
            coordinator: coordinator,
            hapticFeedbackManager: HapticFeedbackManager(),
            appSettingsManager: AppSettingsManager(),
            gameSettingsManager: GameSettingsManager()
        )
        
        let menuView = MenuView(viewModel: menuViewModel)
        return menuView
    }
}
