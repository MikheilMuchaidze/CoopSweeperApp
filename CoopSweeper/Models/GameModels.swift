//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import Foundation

enum GameDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case custom = "Custom"
}

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

final class GameState: ObservableObject {
    @Published var cells: [[Cell]]
    @Published var gameOver: Bool = false
    @Published var gameWon: Bool = false
    @Published var remainingMines: Int
    
    let rows: Int
    let columns: Int
    let totalMines: Int
    
    init(
        rows: Int = 9,
        columns: Int = 9,
        mines: Int = 10
    ) {
        self.rows = rows
        self.columns = columns
        self.totalMines = mines
        self.remainingMines = mines
        
        // Initialize empty board
        var newCells: [[Cell]] = []
        for row in 0..<rows {
            var rowCells: [Cell] = []
            for col in 0..<columns {
                rowCells.append(
                    Cell(
                        row: row,
                        column: col,
                        isMine: false,
                        state: .hidden,
                        adjacentMines: 0
                    )
                )
            }
            newCells.append(rowCells)
        }
        self.cells = newCells
        
        // Place mines randomly
        placeMines()
        
        // Calculate adjacent mines
        calculateAdjacentMines()
    }
    
    private func placeMines() {
        var minesPlaced = 0
        while minesPlaced < totalMines {
            let randomRow = Int.random(in: 0..<rows)
            let randomCol = Int.random(in: 0..<columns)
            
            if !cells[randomRow][randomCol].isMine {
                cells[randomRow][randomCol].isMine = true
                minesPlaced += 1
            }
        }
    }
    
    private func calculateAdjacentMines() {
        for row in 0..<rows {
            for col in 0..<columns {
                if !cells[row][col].isMine {
                    var count = 0
                    for r in max(0, row-1)...min(rows-1, row+1) {
                        for c in max(0, col-1)...min(columns-1, col+1) {
                            if cells[r][c].isMine {
                                count += 1
                            }
                        }
                    }
                    cells[row][col].adjacentMines = count
                }
            }
        }
    }
    
    func revealCell(row: Int, column: Int) {
        guard !gameOver && !gameWon else { return }
        guard row >= 0 && row < rows && column >= 0 && column < columns else { return }
        
        let cell = cells[row][column]
        guard cell.state == .hidden else { return }
        
        cells[row][column].state = .revealed
        
        if cell.isMine {
            gameOver = true
            revealAllMines()
            return
        }
        
        if cell.adjacentMines == 0 {
            // Reveal adjacent cells for empty cells
            for r in max(0, row-1)...min(rows-1, row+1) {
                for c in max(0, column-1)...min(columns-1, column+1) {
                    if cells[r][c].state == .hidden {
                        revealCell(row: r, column: c)
                    }
                }
            }
        }
        
        checkWinCondition()
    }
    
    func toggleFlag(row: Int, column: Int) {
        guard !gameOver && !gameWon else { return }
        guard row >= 0 && row < rows && column >= 0 && column < columns else { return }
        
        let cell = cells[row][column]
        guard cell.state == .hidden || cell.state == .flagged else { return }
        
        if cell.state == .hidden {
            cells[row][column].state = .flagged
            remainingMines -= 1
        } else {
            cells[row][column].state = .hidden
            remainingMines += 1
        }
        
        checkWinCondition()
    }
    
    private func revealAllMines() {
        for row in 0..<rows {
            for col in 0..<columns {
                if cells[row][col].isMine {
                    cells[row][col].state = .revealed
                }
            }
        }
    }
    
    private func checkWinCondition() {
        var unrevealedNonMines = 0
        for row in 0..<rows {
            for col in 0..<columns {
                if !cells[row][col].isMine && cells[row][col].state == .hidden {
                    unrevealedNonMines += 1
                }
            }
        }
        gameWon = unrevealedNonMines == 0
    }
    
    func resetGame() {
        gameOver = false
        gameWon = false
        remainingMines = totalMines
        
        // Reset all cells
        for row in 0..<rows {
            for col in 0..<columns {
                cells[row][col].state = .hidden
            }
        }
        
        // Place new mines
        placeMines()
        calculateAdjacentMines()
    }
} 
