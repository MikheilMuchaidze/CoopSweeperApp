//
//  GameResultsModel.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 07.04.25.
//

import Foundation

struct GameResultsModel {
    let playerName: String
    let time: TimeInterval
    let minesFound: Int
    let totalMines: Int
    let gameWon: Bool
}
