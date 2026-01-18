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
    var gameDifficulties: [GameDifficulty] { get }
    var selectedGameDifficulty: GameDifficulty { get set }
    var selectedCustomWidthForBoard: Int { get set }
    var selectedCustomHeightForBoard: Int { get set }
    var selectedCustomMinesForBoard : Int { get set }
    
    func presentGameModeHintView()
    func presentGameDifficultyHintView()
    func presentGameHistoryView()
    func presentSettingsView()
    func updateGameMode(with newValue: GameMode)
    func updateGameDifficulty(with newValue: GameDifficulty)
    func updateCustomGameWidth(with newValue: Int)
    func updateCustomGameHeight(with newValue: Int)
    func updateCustomGameMines(with newValue: Int)
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
    var gameDifficulties: [GameDifficulty] = GameDifficulty.allCases
//    var selectedGameDifficulty: GameDifficulty = .easy
    var selectedGameDifficulty: GameDifficulty = .custom
    var selectedCustomWidthForBoard = 9
    var selectedCustomHeightForBoard = 9
    var selectedCustomMinesForBoard = 10
    
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
        hapticFeedbackManager.impact(style: .soft)
    }
    
    func updateGameDifficulty(with newValue: GameDifficulty) {
        selectedGameDifficulty = newValue
        gameSettingsManager.updateGameSettings(
            with: .difficulty(
                newValue
            )
        )
        hapticFeedbackManager.impact(style: .soft)
    }
    
    func updateCustomGameWidth(with newValue: Int) {
        hapticFeedbackManager.impact(style: .soft)
        selectedCustomWidthForBoard = newValue
        gameSettingsManager.updateGameSettings(
            with: .customWidth(
                newValue
            )
        )
    }
    
    func updateCustomGameHeight(with newValue: Int) {
        hapticFeedbackManager.impact(style: .soft)
        selectedCustomHeightForBoard = newValue
        gameSettingsManager.updateGameSettings(
            with: .customHeight(
                newValue
            )
        )
    }
    
    func updateCustomGameMines(with newValue: Int) {
        hapticFeedbackManager.impact(style: .soft)
        selectedCustomMinesForBoard = newValue
        gameSettingsManager.updateGameSettings(
            with: .customMines(
                newValue
            )
        )
    }
}
