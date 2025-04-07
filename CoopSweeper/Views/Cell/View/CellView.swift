//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

struct CellView: View {
    // MARK: - Private Properties

    private let cell: Cell
    private let size: CGFloat

    // MARK: - Init

    init(cell: Cell, size: CGFloat) {
        self.cell = cell
        self.size = size
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
                .border(Color.gray.opacity(0.3), width: 1)
            
            if cell.isRevealed {
                if cell.isMine {
                    Image(systemName: "burst.fill")
                        .foregroundColor(.red)
                } else if cell.adjacentMines > 0 {
                    Text("\(cell.adjacentMines)")
                        .font(.system(size: size * 0.6, weight: .bold))
                        .foregroundColor(numberColor)
                }
            } else if cell.isFlagged {
                Image(systemName: "flag.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Body Components

extension CellView {
    private var backgroundColor: Color {
        if cell.isRevealed {
            return cell.isMine ? .red.opacity(0.3) : .gray.opacity(0.1)
        }
        return .white
    }

    private var numberColor: Color {
        return switch cell.adjacentMines {
        case 1: .blue
        case 2: .green
        case 3: .red
        case 4: .purple
        case 5: .orange
        case 6: .teal
        case 7: .black
        case 8: .gray
        default: .black
        }
    }
}

// MARK: - Preview

#Preview {
    CellView(
        cell: Cell(
            row: 0,
            column: 0,
            isMine: false,
            state: .hidden,
            adjacentMines: 0
        ),
        size: 35
    )
}
