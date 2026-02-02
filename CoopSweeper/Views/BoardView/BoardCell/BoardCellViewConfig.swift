//
//  BoardCellViewConfig.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 25.01.2026.
//

import Foundation

struct BoardCellViewConfig: Identifiable {
    let id = UUID()
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
}
