//
//  GameSettingsManager.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import Foundation

protocol GameSettingsManager {
    // Observed
    var playerName: String { get }
    var difficulty: GameDifficulty { get }
    var gameMode: GameMode { get }
    var customWidth: Int { get }
    var customHeight: Int { get }
    var customMines: Int { get }

    // Not Observed
    var boardWidth: Int { get }
    var boardHeight: Int { get }
    var mineCount: Int { get }

    func updateGameSettings(with update: GameSettingsUpdate)
}

@Observable
final class DefaultGameSettingsManager: GameSettingsManager {
    // MARK: - Published Properties

    // General settings
    var playerName: String = ""
    var difficulty: GameDifficulty = .easy
    var gameMode: GameMode = .local
    // Custom difficulty settings
    var customWidth: Int = 9
    var customHeight: Int = 9
    var customMines: Int = 10

    // MARK: - Properties

    @ObservationIgnored var boardWidth: Int {
        switch difficulty {
        case .easy: return 9
        case .medium: return 16
        case .hard: return 30
        case .custom: return customWidth
        }
    }

    @ObservationIgnored var boardHeight: Int {
        switch difficulty {
        case .easy: return 9
        case .medium: return 16
        case .hard: return 16
        case .custom: return customHeight
        }
    }

    @ObservationIgnored var mineCount: Int {
        switch difficulty {
        case .easy: return 10
        case .medium: return 40
        case .hard: return 99
        case .custom: return customMines
        }
    }

    // MARK: - Methods

    func updateGameSettings(with update: GameSettingsUpdate) {
        switch update {
        case let .difficulty(gameDifficulty):
            difficulty = gameDifficulty
        case let .mode(gameMode):
            self.gameMode = gameMode
        case let .customWidth(width):
            customWidth = width
        case let .customHeight(height):
            customHeight = height
        case let .customMines(mines):
            customMines = mines
        }
    }
}

enum GameSettingsUpdate {
    case difficulty(GameDifficulty)
    case mode(GameMode)
    case customWidth(Int)
    case customHeight(Int)
    case customMines(Int)
}

