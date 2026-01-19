//
//  NavigationRoutes.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import Foundation

enum NavigationRoutes: NavigationPathProtocol {
    case boardView(inputs: BoardViewConfiguratorInputs)

    var id: String {
        switch self {
        case .boardView:
            "boardView"
        }
    }
    
    static var allCases: [NavigationRoutes] {
        [
            .boardView(
                inputs: BoardViewConfiguratorInputs(
                    coordinator: Coordinator(),
                    hapticFeedbackManager: HapticFeedbackManager(),
                    appSettingsManager: AppSettingsManager(),
                    gameSettingsManager: GameSettingsManager()
                )
            )
        ]
    }
}
