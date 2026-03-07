//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

@main
struct CoopSweeperApp: App {
    // MARK: - Coordinator

    @State private var coordinator: CoordinatorProtocol
    
    // MARK: - Managers
    
    private let hapticFeedbackManager: HapticFeedbackManagerProtocol
    private let appSettingsManager: AppSettingsManagerProtocol
    private let gameSettingsManager: GameSettingsManagerProtocol
    private let gameHistoryManager: GameHistoryManagerProtocol
    
    // MARK: - Init
    
    init() {
        self.coordinator = Coordinator()
        self.hapticFeedbackManager = HapticFeedbackManager()
        self.appSettingsManager = AppSettingsManager()
        self.gameSettingsManager = GameSettingsManager()
        self.gameHistoryManager = GameHistoryManager()
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                MenuViewConfigurator.configureView(
                    inputs: MenuViewConfiguratorInputs(
                        coordinator: coordinator,
                        hapticFeedbackManager: hapticFeedbackManager,
                        appSettingsManager: appSettingsManager,
                        gameSettingsManager: gameSettingsManager,
                        gameHistoryManager: gameHistoryManager
                    )
                )
                    .registerViewsFor(navigationPaths: NavigationRoutes.allCases)
                    .registerSheetViewsFor(sheetDestinations: $coordinator.presentedSheet)
            }
        }
    }
}
