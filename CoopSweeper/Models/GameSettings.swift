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
} 
