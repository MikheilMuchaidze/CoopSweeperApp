//
//  BoardView.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

struct BoardView: View {
    // MARK: - ViewModel
    
    @State private var viewModel: BoardViewModelProtocol
    
    // MARK: - Init
    
    init(
        viewModel: BoardViewModelProtocol
    ) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        AppConstants.mainBackgroundColor
            .overlay(content: content)
    }
}

// MARK: - Body Components

extension BoardView {
    private func content() -> some View {
        Text("Board View")
    }
}

//struct BoardView: View {
//    // MARK: - Private Properties
//
//    @Environment(\.appSettingsManager) var appSettingsManager
//    @Environment(\.gameSettingsManager) var gameSettingsManager
//
//    // MARK: - State Properties
//
//    @State private var gameEngineManager: GameEngineManager
//    @State private var cellSize: CGFloat = 35
//    @State private var startTime: Date?
//    @State private var elapsedTime: TimeInterval = 0
//    @State private var timer: Timer?
//    @State private var showGameResults = false
//    @State private var gameResults: GameResultsModel?
//    @State private var scale: CGFloat = 1.0
//    @State private var lastScale: CGFloat = 1.0
//    @State private var offset: CGSize = .zero
//    @State private var lastOffset: CGSize = .zero
//
//    // MARK: - Environment Properties
//
//    @Environment(\.dismiss) private var dismiss
//
//    // MARK: - Init
//
//    init(gameEngineManager: GameEngineManager) {
//        self.gameEngineManager = gameEngineManager
//    }
//
//    // MARK: - Body
//
//    var body: some View {
//        VStack(spacing: 0) {
//            VStack(spacing: 8) {
//                playerNameSection
//                minesCountSection
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color(.systemGray6))
//
//            boardViewSection
//
//            VStack(spacing: 12) {
//                timerView
//                HStack(spacing: 20) {
//                    reloadGameButtonView
//                    endGameButtonView
//                }
//            }
//            .padding()
//            .background(Color(.systemGray6))
//        }
//        .onAppear {
//            startTimer()
//        }
//        .onDisappear {
//            stopTimer()
//        }
//        .alert("Game Over", isPresented: $showGameResults) {
//            Button("OK") {
//                dismiss()
//            }
//        } message: {
//            if let results = gameResults {
//                Text("""
//                    Player: \(results.playerName)
//                    Time: \(String(format: "%.1f", results.time))s
//                    Mines Found: \(results.minesFound)/\(results.totalMines)
//                    Result: \(results.gameWon ? "Won" : "Lost")
//                    """)
//            }
//        }
//    }
//    
//    // MARK: - Private Methods
//    
//    private func startTimer() {
//        startTime = Date()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            if let startTime = startTime {
//                elapsedTime = Date().timeIntervalSince(startTime)
//            }
//        }
//    }
//    
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//    
//    private func resetTimer() {
//        stopTimer()
//        startTime = Date()
//        elapsedTime = 0
//        startTimer()
//    }
//    
//    private func checkGameState() {
//        if gameEngineManager.gameOver || gameEngineManager.gameWon {
//            stopTimer()
//            let results = GameResultsModel(
//                playerName: gameSettingsManager.playerName,
//                time: elapsedTime,
//                minesFound: gameEngineManager.totalMines - gameEngineManager.remainingMines,
//                totalMines: gameEngineManager.totalMines,
//                gameWon: gameEngineManager.gameWon
//            )
//            gameResults = results
//            showGameResults = true
//        }
//    }
//    
//    private func endGame() {
//        stopTimer()
//        let results = GameResultsModel(
//            playerName: gameSettingsManager.playerName,
//            time: elapsedTime,
//            minesFound: gameEngineManager.totalMines - gameEngineManager.remainingMines,
//            totalMines: gameEngineManager.totalMines,
//            gameWon: false
//        )
//        gameResults = results
//        showGameResults = true
//    }
//
//    private func formatTime(_ timeInterval: TimeInterval) -> String {
//        let minutes = Int(timeInterval) / 60
//        let seconds = Int(timeInterval) % 60
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
//}

// MARK: - Body Components

//extension BoardView {
//    private var playerNameSection: some View {
//        Text(gameSettingsManager.playerName + "is playing")
//            .font(.title2)
//            .bold()
//    }
//
//    private var minesCountSection: some View {
//        Text("Mines: \(gameEngineManager.remainingMines)/\(gameEngineManager.totalMines)")
//            .font(.title3)
//    }
//
//    private var boardViewSection: some View {
//        GeometryReader { geometry in
//            ScrollView([.horizontal, .vertical], showsIndicators: false) {
//                boardContent
//                    .scaleEffect(scale)
//                    .gesture(magnificationGesture)
//                    .gesture(dragGesture)
//            }
//        }
//    }
//
//    private var boardContent: some View {
//        VStack(spacing: 0) {
//            ForEach(0..<gameEngineManager.rows, id: \.self) { row in
//                HStack(spacing: 0) {
//                    ForEach(0..<gameEngineManager.columns, id: \.self) { column in
//                        CellView(
//                            cell: gameEngineManager.cells[row][column],
//                            size: cellSize
//                        )
//                        .onTapGesture {
//                            gameEngineManager.revealCell(row: row, column: column)
//                            checkGameState()
//                        }
//                        .onLongPressGesture {
//                            gameEngineManager.toggleFlag(row: row, column: column)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private var magnificationGesture: some Gesture {
//        MagnificationGesture()
//            .onChanged { value in
//                let delta = value / lastScale
//                lastScale = value
//                scale = min(max(0.5, scale * delta), 3.0)
//            }
//            .onEnded { _ in
//                lastScale = 1.0
//            }
//    }
//
//    private var dragGesture: some Gesture {
//        DragGesture()
//            .onChanged { value in
//                offset = CGSize(
//                    width: lastOffset.width + value.translation.width,
//                    height: lastOffset.height + value.translation.height
//                )
//            }
//            .onEnded { _ in
//                lastOffset = offset
//            }
//    }
//
//    private var timerView: some View {
//        VStack(spacing: 5) {
//            Text("Time")
//                .font(.headline)
//                .foregroundColor(.secondary)
//
//            Text(formatTime(elapsedTime))
//                .font(.system(size: 30, weight: .bold, design: .monospaced))
//                .foregroundColor(.primary)
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(15)
//    }
//
//    private var reloadGameButtonView: some View {
//        Button {
//            gameEngineManager.resetGame()
//            resetTimer()
//        } label: {
//            Label("Reload", systemImage: "arrow.clockwise")
//                .font(.title3)
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(10)
//        }
//    }
//
//    private var endGameButtonView: some View {
//        Button {
//            endGame()
//        } label: {
//            Label("End Game", systemImage: "xmark.circle.fill")
//                .font(.title3)
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.red)
//                .cornerRadius(10)
//        }
//    }
//}

// MARK: - Preview

//#Preview {
//    NavigationStack {
//        let defaultGameEngineManager = DefaultGameEngineManager(
//            rows: 12,
//            columns: 12,
//            totalMines: 10
//        )
//        let defaultGameSettingsManager = DefaultGameSettingsManager()
//        defaultGameSettingsManager.updateGameSettings(with: .playerName("123ijij"))
//        return BoardView(gameEngineManager: defaultGameEngineManager)
//            .environment(\.appSettingsManager, DefaultAppSettingsManager())
//            .environment(\.gameSettingsManager, defaultGameSettingsManager)
//    }
//}
