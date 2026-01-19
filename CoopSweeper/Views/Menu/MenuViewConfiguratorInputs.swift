//
//  MenuViewConfiguratorInputs.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 19.01.2026.
//

import Foundation

struct MenuViewConfiguratorInputs {
    // MARK: - Properties
    
    let coordinator: any CoordinatorProtocol
    let hapticFeedbackManager: HapticFeedbackManagerProtocol
    let appSettingsManager: AppSettingsManagerProtocol
    let gameSettingsManager: GameSettingsManagerProtocol
    
    // MARK: - Init
    
    init(
        coordinator: any CoordinatorProtocol,
        hapticFeedbackManager: HapticFeedbackManagerProtocol,
        appSettingsManager: AppSettingsManagerProtocol,
        gameSettingsManager: GameSettingsManagerProtocol
    ) {
        self.coordinator = coordinator
        self.hapticFeedbackManager = hapticFeedbackManager
        self.appSettingsManager = appSettingsManager
        self.gameSettingsManager = gameSettingsManager
    }
}

