//
//  BoardViewConfiguratorInputs.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 19.01.2026.
//

import Foundation

struct BoardViewConfiguratorInputs {
    // MARK: - Properties
    
    let coordinator: any CoordinatorProtocol
    let hapticFeedbackManager: HapticFeedbackManagerProtocol
    let appSettingsManager: AppSettingsManagerProtocol
    let gameSettingsManager: GameSettingsManagerProtocol
    let gameEngineManager: GameEngineManagerProtocol
    
    // MARK: - Init
    
    init(
        coordinator: any CoordinatorProtocol,
        hapticFeedbackManager: HapticFeedbackManagerProtocol,
        appSettingsManager: AppSettingsManagerProtocol,
        gameSettingsManager: GameSettingsManagerProtocol,
        gameEngineManager: GameEngineManagerProtocol
    ) {
        self.coordinator = coordinator
        self.hapticFeedbackManager = hapticFeedbackManager
        self.appSettingsManager = appSettingsManager
        self.gameSettingsManager = gameSettingsManager
        self.gameEngineManager = gameEngineManager
    }
}
