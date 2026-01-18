//
//  DifficultyButton.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import SwiftUI

struct DifficultyButton: View {
    // MARK: - Private Properties
    
    private let difficulty: GameDifficulty
    private let isSelected: Bool
    private let action: () -> Void
    
    // MARK: - Init
    
    init(
        difficulty: GameDifficulty,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.difficulty = difficulty
        self.isSelected = isSelected
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(difficulty.rawValue)
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(
                        isSelected
                        ? Color(red: 0.3, green: 0.7, blue: 0.9)
                        : .white.opacity(0.8)
                    )
                
                if let boardSize = difficulty.boardSize {
                    Text(boardSize)
                        .font(
                            .system(
                                size: 12,
                                weight: .medium,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(
                            isSelected
                            ? Color(red: 0.3, green: 0.7, blue: 0.9).opacity(0.7)
                            : .white.opacity(0.5)
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .opacity(isSelected ? 0.8 : 0.5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isSelected ? Color(red: 0.3, green: 0.7, blue: 0.9) : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
