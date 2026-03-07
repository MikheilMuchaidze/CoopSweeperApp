//
//  BoardCellViewConfig.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 25.01.2026.
//

import Foundation

struct BoardCellViewConfig: Identifiable, Codable {
    let id: UUID
    let row: Int
    let column: Int
    var isMine: Bool
    var state: BoardCellState
    var adjacentMines: Int

    var isRevealed: Bool {
        state == .revealed
    }

    var isFlagged: Bool {
        state == .flagged
    }

    init(
        id: UUID = UUID(),
        row: Int,
        column: Int,
        isMine: Bool,
        state: BoardCellState,
        adjacentMines: Int
    ) {
        self.id = id
        self.row = row
        self.column = column
        self.isMine = isMine
        self.state = state
        self.adjacentMines = adjacentMines
    }
}
