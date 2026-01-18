//
//  MenuViewModel.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import Foundation

protocol MenuViewModelProtocol {
    var gameModes: [GameMode] { get }
    var selectedGameMode: GameMode { get set }
    
    func presentGameModeHintView()
    func presentGameDifficultyHintView()
    func presentGameHistoryView()
    func presentSettingsView()
    func updateGameMode(with newValue: GameMode)
}

@Observable
final class MenuViewModel: MenuViewModelProtocol {
    // MARK: - Coordinator
    
    private var coordinator: any CoordinatorProtocol
    
    // MARK: - Private Properties
    
    private let hapticFeedbackManager: HapticFeedbackManagerProtocol
    private let appSettingsManager: AppSettingsManagerProtocol
    private let gameSettingsManager: GameSettingsManagerProtocol
    
    // MARK: - Shared Properties
    
    var gameModes: [GameMode] = GameMode.allCases
    var selectedGameMode: GameMode = .local
    
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
    
    // MARK: - Methods
    
    func presentGameModeHintView() {
        hapticFeedbackManager.selection()
        coordinator.present(sheet: .gameModeHintView)
    }
    
    func presentGameDifficultyHintView() {
        hapticFeedbackManager.selection()
        coordinator.present(sheet: .gameDifficultyHintView)
    }
    
    func presentGameHistoryView() {
        hapticFeedbackManager.selection()
        coordinator.present(sheet: .gameHistoryView)
    }
    
    func presentSettingsView() {
        hapticFeedbackManager.selection()
        let settingsViewInputs = SettingsConfiguratorInputs(
            coordinator: coordinator,
            appSettingsManager: appSettingsManager
        )
        coordinator.present(sheet: .settingsView(input: settingsViewInputs))
    }
    
    func updateGameMode(with newValue: GameMode) {
        selectedGameMode = newValue
        gameSettingsManager.updateGameSettings(
            with: .mode(
                newValue
            )
        )
    }
}
