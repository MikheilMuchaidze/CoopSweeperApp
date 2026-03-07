//
//  GameHistoryViewModel.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 01.03.26.
//

import Foundation

// MARK: - Filter Types

enum HistorySection: String, CaseIterable {
    case recent = "Recent"
    case difficulty = "Difficulty"
    case gameMode = "Game Mode"
}

// MARK: - Protocol

protocol GameHistoryViewModelProtocol: AnyObject {
    var selectedSection: HistorySection { get set }
    var selectedDifficulty: GameDifficulty { get set }
    var selectedMode: GameMode { get set }
    var recentGames: [GameResultsModel] { get }
    var filteredByDifficulty: [GameResultsModel] { get }
    var filteredByMode: [GameResultsModel] { get }
    var hasGames: Bool { get }
    
    func clearHistory()
    func refreshGames()
}

// MARK: - Implementation

@Observable
final class GameHistoryViewModel: GameHistoryViewModelProtocol {
    // MARK: - Properties
    
    var selectedSection: HistorySection = .recent
    var selectedDifficulty: GameDifficulty = .easy
    var selectedMode: GameMode = .local
    
    var recentGames: [GameResultsModel] {
        gameHistoryManager.recentGames
    }
    
    var filteredByDifficulty: [GameResultsModel] {
        gameHistoryManager.games(forDifficulty: selectedDifficulty)
    }
    
    var filteredByMode: [GameResultsModel] {
        gameHistoryManager.games(forMode: selectedMode)
    }
    
    var hasGames: Bool {
        !gameHistoryManager.games.isEmpty
    }
    
    // MARK: - Private Properties
    
    private let gameHistoryManager: GameHistoryManagerProtocol
    
    // MARK: - Init
    
    init(gameHistoryManager: GameHistoryManagerProtocol) {
        self.gameHistoryManager = gameHistoryManager
    }
    
    // MARK: - Methods
    
    func clearHistory() {
        gameHistoryManager.clearHistory()
    }
    
    func refreshGames() {
        // Triggers observation refresh by accessing games
        _ = gameHistoryManager.games
    }
}
