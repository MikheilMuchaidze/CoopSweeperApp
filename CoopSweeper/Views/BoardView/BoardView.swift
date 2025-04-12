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

    @Environment(\.appSettingsManager) var appSettingsManager
    @Environment(\.gameSettingsManager) var gameSettingsManager

    // MARK: - State Properties

    @State private var gameEngineManager: GameEngineManager
    @State private var cellSize: CGFloat = 35
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showGameResults = false
    @State private var gameResults: GameResultsModel?

    // MARK: - Environment Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    init(gameEngineManager: GameEngineManager) {
        self.gameEngineManager = gameEngineManager
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            mineCountView
                .padding(.horizontal)

            boardView
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()

            Spacer()

            timerView
                .padding(.bottom, 20)

            gameControlsView
                .padding(.horizontal)
                .padding(.bottom, 30)
        }
        .padding()
        .navigationTitle(gameSettingsManager.playerName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showGameResults = true
                    gameResults = GameResultsModel(
                        playerName: gameSettingsManager.playerName,
                        time: elapsedTime,
                        minesFound: gameEngineManager.totalMines - gameEngineManager.remainingMines,
                        totalMines: gameEngineManager.totalMines,
                        gameWon: gameEngineManager.gameWon
                    )
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .alert("Game Results", isPresented: $showGameResults) {
            Button("End Game") {
                dismiss()
            }
        } message: {
            if let results = gameResults {
                Text("""
                    Player: \(results.playerName)
                    Time: \(formatTime(results.time))
                    Mines Found: \(results.minesFound)/\(results.totalMines)
                    Status: \(results.gameWon ? "Won! 🎉" : "Lost 😔")
                    """)
            }
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
    private var mineCountView: some View {
        HStack {
            Text("Mines: \(gameEngineManager.remainingMines)")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }

    private var timerView: some View {
        VStack(spacing: 5) {
            Text("Time")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(formatTime(elapsedTime))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }

    private var gameControlsView: some View {
        HStack(spacing: 20) {
            Button {
                gameEngineManager.resetGame()
                resetTimer()
            } label: {
                Label("New Game", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
        }
    }

    private var boardView: some View {
        VStack(spacing: 0) {
            ForEach(0..<gameEngineManager.rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gameEngineManager.columns, id: \.self) { column in
                        CellView(cell: gameEngineManager.cells[row][column], size: cellSize)
                            .onTapGesture {
                                if gameEngineManager.cells[row][column].state == .hidden {
                                    startTimer()
                                }
                                if appSettingsManager.vibrationEnabled {
                                    // Add vibration feedback
                                }
                                gameEngineManager.revealCell(row: row, column: column)
                            }
                            .onLongPressGesture {
                                if appSettingsManager.vibrationEnabled {
                                    // Add vibration feedback
                                }
                                gameEngineManager.toggleFlag(row: row, column: column)
                            }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BoardView(
            gameEngineManager: DefaultGameEngineManager(
                rows: 12,
                columns: 12,
                totalMines: 10
            )
        )
        .environment(\.appSettingsManager, DefaultAppSettingsManager())
        .environment(\.gameSettingsManager, DefaultGameSettingsManager())
    }
}
