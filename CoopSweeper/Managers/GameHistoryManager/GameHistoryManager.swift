//
//  GameHistoryManager.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 01.03.26.
//

import Foundation

// MARK: - Protocol

protocol GameHistoryManagerProtocol {
    var games: [GameResultsModel] { get }
    var recentGames: [GameResultsModel] { get }

    func saveGame(_ result: GameResultsModel)
    func clearHistory()
    func games(forDifficulty difficulty: GameDifficulty) -> [GameResultsModel]
    func games(forMode mode: GameMode) -> [GameResultsModel]
}

// MARK: - Implementation

@Observable
final class GameHistoryManager: GameHistoryManagerProtocol {
    // MARK: - Properties

    private(set) var games: [GameResultsModel] = []

    var recentGames: [GameResultsModel] {
        Array(games.prefix(10))
    }

    // MARK: - Private Properties

    @ObservationIgnored
    private let userDefaults: UserDefaults
    @ObservationIgnored
    private let storageKey = "gameHistory"

    // MARK: - Init

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadGames()
    }

    // MARK: - Methods

    func saveGame(_ result: GameResultsModel) {
        games.insert(result, at: 0)
        persistGames()
    }

    func clearHistory() {
        games.removeAll()
        persistGames()
    }

    func games(forDifficulty difficulty: GameDifficulty) -> [GameResultsModel] {
        games.filter { $0.difficulty == difficulty }
    }

    func games(forMode mode: GameMode) -> [GameResultsModel] {
        games.filter { $0.gameMode == mode }
    }

    // MARK: - Private Methods

    private func loadGames() {
        guard let data = userDefaults.data(forKey: storageKey) else { return }
        do {
            games = try JSONDecoder().decode([GameResultsModel].self, from: data)
        } catch {
            games = []
        }
    }

    private func persistGames() {
        do {
            let data = try JSONEncoder().encode(games)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            // Silently fail — non-critical persistence
        }
    }
}
