//
//  GameResultsModel.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 07.04.25.
//

import Foundation

struct GameResultsModel: Codable, Identifiable {
    let id: UUID
    let playerName: String
    let time: TimeInterval
    let minesFound: Int
    let totalMines: Int
    let gameWon: Bool
    let difficulty: GameDifficulty
    let gameMode: GameMode
    let boardWidth: Int
    let boardHeight: Int
    let date: Date
    let finalBoard: [[BoardCellViewConfig]]
    let triggerCellRow: Int?
    let triggerCellColumn: Int?

    init(
        id: UUID = UUID(),
        playerName: String,
        time: TimeInterval,
        minesFound: Int,
        totalMines: Int,
        gameWon: Bool,
        difficulty: GameDifficulty,
        gameMode: GameMode,
        boardWidth: Int,
        boardHeight: Int,
        date: Date = Date(),
        finalBoard: [[BoardCellViewConfig]] = [],
        triggerCellRow: Int? = nil,
        triggerCellColumn: Int? = nil
    ) {
        self.id = id
        self.playerName = playerName
        self.time = time
        self.minesFound = minesFound
        self.totalMines = totalMines
        self.gameWon = gameWon
        self.difficulty = difficulty
        self.gameMode = gameMode
        self.boardWidth = boardWidth
        self.boardHeight = boardHeight
        self.date = date
        self.finalBoard = finalBoard
        self.triggerCellRow = triggerCellRow
        self.triggerCellColumn = triggerCellColumn
    }
}
