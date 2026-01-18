//
//  NavigationSheets.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import Foundation

enum NavigationSheets: NavigationPathProtocol {
    case gameModeHintView
    case gameDifficultyHintView
    case settingsView(input: SettingsConfiguratorInputs)
    case gameHistoryView

    var id: String {
        switch self {
        case .gameModeHintView:
            "gameModeHintView"
        case .gameDifficultyHintView:
            "gameDifficultyHintView"
        case .settingsView:
            "settingsView"
        case .gameHistoryView:
            "gameHistoryView"
        }
    }
    
    static var allCases: [NavigationSheets] {
        [
            .gameModeHintView,
            .gameDifficultyHintView,
            .settingsView(
                input: SettingsConfiguratorInputs(
                    coordinator: Coordinator(),
                    appSettingsManager: AppSettingsManager()
                )
            ),
            .gameHistoryView
        ]
    }
}
