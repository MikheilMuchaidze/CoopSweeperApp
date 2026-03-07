//
//  GameHistoryItemView.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 12.04.25.
//

import SwiftUI

struct GameHistoryItemView: View {
    // MARK: - Properties

    let game: GameResultsModel

    // MARK: - Private Properties

    private var formattedTime: String {
        let minutes = Int(game.time) / 60
        let seconds = Int(game.time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: game.date, relativeTo: Date())
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            resultIcon
            gameInfo
            Spacer()
            badges
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(
                    game.gameWon
                    ? Color.yellow.opacity(0.2)
                    : Color.red.opacity(0.15),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Subviews

extension GameHistoryItemView {
    private var resultIcon: some View {
        Image(systemName: game.gameWon ? "trophy.fill" : "xmark.circle.fill")
            .font(.system(size: 28))
            .foregroundStyle(game.gameWon ? Color.yellow : Color.red.opacity(0.8))
    }

    private var displayName: String {
        game.playerName.isEmpty ? "Player" : game.playerName
    }

    private var gameInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(game.gameWon ? "\(displayName) Won" : "\(displayName) Defeated")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)

            HStack(spacing: 10) {
                Label(formattedTime, systemImage: "stopwatch")
                Label(
                    "\(game.minesFound)/\(game.totalMines)",
                    systemImage: "asterisk"
                )
                Label(
                    "\(game.boardWidth)×\(game.boardHeight)",
                    systemImage: "square.grid.3x3"
                )
            }
            .font(.system(size: 11))
            .foregroundStyle(.white.opacity(0.45))
        }
    }

    private var badges: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text(formattedDate)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.35))

            HStack(spacing: 4) {
                badge(game.difficulty.rawValue, color: difficultyColor)
                badge(game.gameMode.rawValue, color: .blue)
            }
        }
    }

    private func badge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(color.opacity(0.35))
            )
    }

    private var difficultyColor: Color {
        switch game.difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        case .custom: return .purple
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 10) {
        GameHistoryItemView(
            game: GameResultsModel(
                playerName: "Player",
                time: 125,
                minesFound: 8,
                totalMines: 10,
                gameWon: true,
                difficulty: .easy,
                gameMode: .local,
                boardWidth: 9,
                boardHeight: 9
            )
        )
        GameHistoryItemView(
            game: GameResultsModel(
                playerName: "TestUser",
                time: 45,
                minesFound: 3,
                totalMines: 40,
                gameWon: false,
                difficulty: .medium,
                gameMode: .coop,
                boardWidth: 16,
                boardHeight: 16
            )
        )
    }
    .padding()
    .background(Color(red: 0.06, green: 0.1, blue: 0.14))
}
