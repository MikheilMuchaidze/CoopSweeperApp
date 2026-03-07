//
//  BoardCellState.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 07.04.25.
//

import Foundation

enum BoardCellState: String, Codable {
    case hidden
    case revealed
    case flagged
}
