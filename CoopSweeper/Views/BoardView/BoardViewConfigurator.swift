//
//  BoardViewConfigurator.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 19.01.2026.
//

import SwiftUI

enum BoardViewConfigurator {
    static func configureView(
        inputs: BoardViewConfiguratorInputs
    ) -> some View {
        let boardViewModel = BoardViewModel(
            coordinator: inputs.coordinator,
            hapticFeedbackManager: inputs.hapticFeedbackManager,
            appSettingsManager: inputs.appSettingsManager,
            gameSettingsManager: inputs.gameSettingsManager
        )
        
        let boardView = BoardView(viewModel: boardViewModel)
        return boardView
    }
}
