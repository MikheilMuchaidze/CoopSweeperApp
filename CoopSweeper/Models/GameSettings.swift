//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import Foundation

final class GameSettings: ObservableObject {
    @Published var playerName: String = ""
    @Published var soundEnabled: Bool = true
    @Published var vibrationEnabled: Bool = true
    @Published var darkMode: Bool = false
    @Published var difficulty: GameDifficulty = .easy
    @Published var gameMode: GameMode = .local
    
    // Custom difficulty settings
    @Published var customWidth: Int = 9
    @Published var customHeight: Int = 9
    @Published var customMines: Int = 10
    
    // Get board dimensions based on difficulty
    var boardWidth: Int {
        switch difficulty {
        case .easy: return 9
        case .medium: return 16
        case .hard: return 30
        case .custom: return customWidth
        }
    }
    
    var boardHeight: Int {
        switch difficulty {
        case .easy: return 9
        case .medium: return 16
        case .hard: return 16
        case .custom: return customHeight
        }
    }
    
    var mineCount: Int {
        switch difficulty {
        case .easy: return 10
        case .medium: return 40
        case .hard: return 99
        case .custom: return customMines
        }
    }
} 
