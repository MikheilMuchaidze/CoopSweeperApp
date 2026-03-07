//
//  GameHistoryDetailView.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 01.03.26.
//

import SwiftUI

struct GameHistoryDetailView: View {
    // MARK: - Properties

    let game: GameResultsModel

    // MARK: - Private Properties

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    private var formattedTime: String {
        let minutes = Int(game.time) / 60
        let seconds = Int(game.time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: game.date)
    }

    private var cellSize: CGFloat {
        let baseSize: CGFloat = 44
        let maxDimension = max(game.boardWidth, game.boardHeight)
        if maxDimension > 16 {
            return baseSize * 0.8
        } else if maxDimension > 12 {
            return baseSize * 0.9
        }
        return baseSize
    }

    // MARK: - Body

    var body: some View {
        AppConstants.mainBackgroundColor
            .overlay(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        resultHeader
                        statsRow
                        boardSection
                        if !game.gameWon, game.triggerCellRow != nil {
                            deathCellInfo
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Result Header

extension GameHistoryDetailView {
    private var displayName: String {
        game.playerName.isEmpty ? "Player" : game.playerName
    }

    private var resultHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: game.gameWon ? "trophy.fill" : "burst.fill")
                .font(.system(size: 56))
                .foregroundStyle(game.gameWon ? Color.yellow : Color.red)

            Text(game.gameWon ? "\(displayName) Won!" : "\(displayName) Defeated")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .tracking(1)
                .multilineTextAlignment(.center)

            Text(formattedDate)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(.top, 12)
    }
}

// MARK: - Stats Row

extension GameHistoryDetailView {
    private var statsRow: some View {
        HStack(spacing: 16) {
            statPill(icon: "stopwatch", label: "Time", value: formattedTime)
            statPill(
                icon: "asterisk",
                label: "Mines",
                value: "\(game.minesFound)/\(game.totalMines)"
            )
            statPill(
                icon: "square.grid.3x3",
                label: "Board",
                value: "\(game.boardWidth)×\(game.boardHeight)"
            )
        }
        .padding(.horizontal, 20)
    }

    private func statPill(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.5))
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.4))
        )
    }
}

// MARK: - Board Section

extension GameHistoryDetailView {
    private var boardSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Final Board")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                HStack(spacing: 4) {
                    badgePill(game.difficulty.rawValue, color: difficultyColor)
                    badgePill(game.gameMode.rawValue, color: .blue)
                }
            }
            .padding(.horizontal, 20)

            if game.finalBoard.isEmpty {
                boardUnavailable
            } else {
                boardGrid
            }
        }
    }

    private var boardUnavailable: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.grid.3x3.slash")
                .font(.system(size: 32))
                .foregroundStyle(.white.opacity(0.3))
            Text("Board data not available for this game.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var boardGrid: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                boardContent
                    .scaleEffect(scale, anchor: .center)
                    .offset(offset)
                    .frame(
                        minWidth: geometry.size.width,
                        minHeight: geometry.size.height
                    )
            }
            .simultaneousGesture(magnificationGesture)
            .simultaneousGesture(dragGesture)
        }
        .frame(height: boardGridHeight)
        .padding(.horizontal, 8)
    }

    private var boardContent: some View {
        VStack(spacing: 2) {
            ForEach(0..<game.finalBoard.count, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<game.finalBoard[row].count, id: \.self) { column in
                        let cell = game.finalBoard[row][column]
                        let isDeath = row == game.triggerCellRow
                            && column == game.triggerCellColumn
                        BoardCellView(
                            cellConfig: cell,
                            size: cellSize,
                            isDeathCell: isDeath
                        )
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 0.06, green: 0.1, blue: 0.14))
                .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(red: 0.3, green: 0.7, blue: 0.9).opacity(0.3), lineWidth: 2)
        )
    }

    private var boardGridHeight: CGFloat {
        let rows = CGFloat(game.finalBoard.count)
        let totalHeight = rows * cellSize + (rows - 1) * 2 + 16
        return min(totalHeight, 400)
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value
                scale = min(max(0.5, scale * delta), 3.0)
            }
            .onEnded { _ in
                lastScale = 1.0
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }

    private func badgePill(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(color.opacity(0.35))
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

// MARK: - Death Cell Info

extension GameHistoryDetailView {
    private var deathCellInfo: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 24))
                .foregroundStyle(.red)

            VStack(alignment: .leading, spacing: 2) {
                Text("Triggered Mine")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                if let row = game.triggerCellRow, let col = game.triggerCellColumn {
                    Text("Cell at row \(row + 1), column \(col + 1)")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.red.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.red.opacity(0.25), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        GameHistoryDetailView(
            game: GameResultsModel(
                playerName: "Player",
                time: 125,
                minesFound: 3,
                totalMines: 10,
                gameWon: false,
                difficulty: .easy,
                gameMode: .local,
                boardWidth: 9,
                boardHeight: 9,
                finalBoard: [],
                triggerCellRow: 4,
                triggerCellColumn: 3
            )
        )
    }
}
