//
//  Cell.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import Foundation

struct Cell: Identifiable {
    let id = UUID()
    let row: Int
    let column: Int
    var isMine: Bool
    var state: CellState
    var adjacentMines: Int

    var isRevealed: Bool {
        state == .revealed
    }

    var isFlagged: Bool {
        state == .flagged
    }
}
