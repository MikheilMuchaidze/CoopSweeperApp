//
//  GameHistoryViewConfiguratorInputs.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 01.03.26.
//

import Foundation

struct GameHistoryViewConfiguratorInputs {
    // MARK: - Properties
    
    let gameHistoryManager: GameHistoryManagerProtocol
    
    // MARK: - Init
    
    init(gameHistoryManager: GameHistoryManagerProtocol) {
        self.gameHistoryManager = gameHistoryManager
    }
}
