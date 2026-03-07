//
//  GameHistoryViewConfigurator.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 01.03.26.
//

import SwiftUI

enum GameHistoryViewConfigurator {
    static func configureView(
        inputs: GameHistoryViewConfiguratorInputs
    ) -> some View {
        let viewModel = GameHistoryViewModel(
            gameHistoryManager: inputs.gameHistoryManager
        )
        
        let view = GameHistoryView(viewModel: viewModel)
        return view
    }
}
