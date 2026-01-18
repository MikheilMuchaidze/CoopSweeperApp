//
//  GameDifficulty.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

enum GameDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case custom = "Custom"
    
    // TODO: - Needs correcting values
    
    var boardSize: String? {
        switch self {
        case .easy:
            "9 x 9"
        case .medium:
            "16 x 16"
        case .hard:
            "32 x 32"
        case .custom:
            nil
        }
    }
    
    var id: String {
        switch self {
        case .easy:
            "easy"
        case .medium:
            "medium"
        case .hard:
            "hard"
        case .custom:
            "custom"
        }
    }
}
