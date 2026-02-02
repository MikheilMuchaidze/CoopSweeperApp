//
//  BoardCellView.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 25.01.2026.
//

import SwiftUI

struct BoardCellView: View {
    // MARK: - Private Properties

    private let cellConfig: BoardCellViewConfig
    private let size: CGFloat

    // MARK: - Init

    init(
        cellConfig: BoardCellViewConfig,
        size: CGFloat
    ) {
        self.cellConfig = cellConfig
        self.size = size
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: size * 0.2, style: .continuous)
                .fill(backgroundColor)
                .frame(width: size - 4, height: size - 4)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.2, style: .continuous)
                        .stroke(borderColor, lineWidth: 1)
                )
                .shadow(
                    color: shadowColor,
                    radius: cellConfig.isRevealed ? 0 : 2,
                    x: 0,
                    y: cellConfig.isRevealed ? 0 : 1
                )
            
            // Content
            cellContent
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Body Components

extension BoardCellView {
    @ViewBuilder
    private var cellContent: some View {
        if cellConfig.isRevealed {
            if cellConfig.isMine {
                // Mine icon
                Image(systemName: "circle.fill")
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundStyle(.white)
                    .overlay(
                        Image(systemName: "sparkle")
                            .font(.system(size: size * 0.2))
                            .foregroundStyle(.white.opacity(0.8))
                            .offset(x: size * 0.12, y: -size * 0.12)
                    )
            } else if cellConfig.adjacentMines > 0 {
                // Number
                Text("\(cellConfig.adjacentMines)")
                    .font(.system(size: size * 0.5, weight: .bold, design: .rounded))
                    .foregroundColor(numberColor)
            }
        } else if cellConfig.isFlagged {
            // Flag icon
            Image(systemName: "flag.fill")
                .font(.system(size: size * 0.4, weight: .medium))
                .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
        }
    }
    
    private var backgroundColor: Color {
        if cellConfig.isRevealed {
            if cellConfig.isMine {
                return Color(red: 0.15, green: 0.2, blue: 0.25)
            }
            return Color(red: 0.08, green: 0.12, blue: 0.16)
        }
        // Hidden cell - slightly lighter dark
        return Color(red: 0.2, green: 0.28, blue: 0.35)
    }
    
    private var borderColor: Color {
        if cellConfig.isRevealed {
            return Color.white.opacity(0.05)
        }
        return Color.white.opacity(0.1)
    }
    
    private var shadowColor: Color {
        Color.black.opacity(0.3)
    }

    private var numberColor: Color {
        switch cellConfig.adjacentMines {
        case 1: return Color(red: 0.3, green: 0.6, blue: 0.9)  // Blue
        case 2: return Color(red: 0.3, green: 0.8, blue: 0.5)  // Green
        case 3: return Color(red: 0.9, green: 0.3, blue: 0.3)  // Red
        case 4: return Color(red: 0.6, green: 0.4, blue: 0.9)  // Purple
        case 5: return Color(red: 0.9, green: 0.5, blue: 0.2)  // Orange
        case 6: return Color(red: 0.3, green: 0.8, blue: 0.8)  // Teal
        case 7: return Color.white
        case 8: return Color.gray
        default: return Color.white
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 4) {
        // Hidden cell
        BoardCellView(
            cellConfig: BoardCellViewConfig(
                row: 0,
                column: 0,
                isMine: false,
                state: .hidden,
                adjacentMines: 0
            ),
            size: 44
        )
        
        // Flagged cell
        BoardCellView(
            cellConfig: BoardCellViewConfig(
                row: 0,
                column: 1,
                isMine: false,
                state: .flagged,
                adjacentMines: 0
            ),
            size: 44
        )
        
        // Revealed with number
        BoardCellView(
            cellConfig: BoardCellViewConfig(
                row: 0,
                column: 2,
                isMine: false,
                state: .revealed,
                adjacentMines: 3
            ),
            size: 44
        )
        
        // Mine
        BoardCellView(
            cellConfig: BoardCellViewConfig(
                row: 0,
                column: 3,
                isMine: true,
                state: .revealed,
                adjacentMines: 0
            ),
            size: 44
        )
    }
    .padding()
    .background(Color(red: 0.05, green: 0.1, blue: 0.15))
}
