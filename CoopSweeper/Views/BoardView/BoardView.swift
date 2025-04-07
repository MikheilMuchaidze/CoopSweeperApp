//
//  BoardView.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI
import Combine

struct BoardView: View {
    // MARK: - Private Properties

    private let gameSettings: GameSettings

    // MARK: - StateObject Properties

    @StateObject private var gameState: GameState

    // MARK: - State Properties

    @State private var cellSize: CGFloat = 35
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?

    // MARK: - Environment Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        // Use default game settings (9x9 with 10 mines)
        _gameState = StateObject(wrappedValue: GameState())
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            playerNameTimerMineCountAndDismissView
                .padding(.horizontal)

            boardView
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()

            // Game status message
            if gameState.gameOver {
                Text("Game Over!")
                    .font(.title)
                    .foregroundColor(.red)
            } else if gameState.gameWon {
                Text("You Won!")
                    .font(.title)
                    .foregroundColor(.green)
            }

            resetButton
                .padding()
        }
        .padding()
        .preferredColorScheme(gameSettings.darkMode ? .dark : .light)
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startTimer() {
        guard startTime == nil else { return }
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        elapsedTime = 0
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Body Components

extension BoardView {
    private var playerNameTimerMineCountAndDismissView: some View {
        HStack {
            Text("Player: \(gameSettings.playerName)")
                .font(.headline)
            Spacer()
            Text("Time: \(formatTime(elapsedTime))")
                .font(.headline)
                .monospacedDigit()
            Spacer()
            Text("Mines: \(gameState.remainingMines)")
                .font(.headline)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
            }
        }
    }

    private var boardView: some View {
        VStack(spacing: 0) {
            ForEach(0..<gameState.rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gameState.columns, id: \.self) { column in
                        CellView(cell: gameState.cells[row][column], size: cellSize)
                            .onTapGesture {
                                if gameState.cells[row][column].state == .hidden {
                                    startTimer()
                                }
                                if gameSettings.vibrationEnabled {
                                    // Add vibration feedback
                                }
                                gameState.revealCell(row: row, column: column)
                            }
                            .onLongPressGesture {
                                if gameSettings.vibrationEnabled {
                                    // Add vibration feedback
                                }
                                gameState.toggleFlag(row: row, column: column)
                            }
                    }
                }
            }
        }
    }

    private var resetButton: some View {
        Button {
            gameState.resetGame()
            resetTimer()
        } label: {
            Image(systemName: "arrow.clockwise")
                .font(.title2)
        }
    }
}

// MARK: - Preview

#Preview {
    BoardView(
        gameSettings: GameSettings()
    )
}
