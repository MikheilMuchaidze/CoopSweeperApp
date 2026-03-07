//
//  BoardViewModel.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 19.01.2026.
//

import Foundation
import AsyncAlgorithms

// MARK: - Interaction Mode

enum CellInteractionMode: String, CaseIterable {
    case reveal = "Reveal"
    case flag = "Flag"
    
    var iconName: String {
        switch self {
        case .reveal: return "square.stack.3d.up"
        case .flag: return "flag.fill"
        }
    }
}

// MARK: - Protocol

protocol BoardViewModelProtocol: AnyObject {
    // Game State
    var cells: [[BoardCellViewConfig]] { get }
    var rows: Int { get }
    var columns: Int { get }
    var remainingMines: Int { get }
    var totalMines: Int { get }
    var isGameOver: Bool { get }
    var isGameWon: Bool { get }
    var isPaused: Bool { get set }
    
    // Timer
    var elapsedTime: TimeInterval { get }
    var formattedTime: String { get }
    
    // Interaction Mode
    var interactionMode: CellInteractionMode { get set }
    
    // Zoom & Pan
    var scale: CGFloat { get set }
    var lastScale: CGFloat { get set }
    var offset: CGSize { get set }
    var lastOffset: CGSize { get set }
    
    // Cell Size
    var cellSize: CGFloat { get }
    
    // Actions
    func onAppear()
    func onDisappear()
    func handleCellTap(row: Int, column: Int)
    func resetGame()
    func quitGame()
    func togglePause()
    func setInteractionMode(_ mode: CellInteractionMode)
}

// MARK: - Implementation

@Observable
final class BoardViewModel: BoardViewModelProtocol {
    // MARK: - Game State
    
    var cells: [[BoardCellViewConfig]] {
        gameEngineManager.cells
    }
    
    var rows: Int {
        gameEngineManager.rows
    }
    
    var columns: Int {
        gameEngineManager.columns
    }
    
    var remainingMines: Int {
        gameEngineManager.remainingMines
    }
    
    var totalMines: Int {
        gameEngineManager.totalMines
    }
    
    var isGameOver: Bool {
        gameEngineManager.gameOver
    }
    
    var isGameWon: Bool {
        gameEngineManager.gameWon
    }
    
    var isPaused: Bool = false
    
    // MARK: - Timer
    
    var elapsedTime: TimeInterval = 0
    
    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Interaction Mode
    
    var interactionMode: CellInteractionMode = .reveal
    
    // MARK: - Zoom & Pan
    
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    
    // MARK: - Cell Size
    
    var cellSize: CGFloat {
        // Adjust cell size based on board dimensions
        let baseSize: CGFloat = 44
        let maxDimension = max(rows, columns)
        if maxDimension > 16 {
            return baseSize * 0.8
        } else if maxDimension > 12 {
            return baseSize * 0.9
        }
        return baseSize
    }
    
    // MARK: - Private Properties
    
    private var coordinator: any CoordinatorProtocol
    private let hapticFeedbackManager: HapticFeedbackManagerProtocol
    private let appSettingsManager: AppSettingsManagerProtocol
    private let gameSettingsManager: GameSettingsManagerProtocol
    private var gameEngineManager: GameEngineManagerProtocol
    private let gameHistoryManager: GameHistoryManagerProtocol
    
    private var timerTask: Task<Void, Never>?
    private var startTime: Date?
    private var didSaveResult: Bool = false
    private var lastTappedRow: Int?
    private var lastTappedColumn: Int?
    
    private let snapshotPlayerName: String
    private let snapshotDifficulty: GameDifficulty
    private let snapshotGameMode: GameMode
    
    // MARK: - Init
    
    init(
        coordinator: any CoordinatorProtocol,
        hapticFeedbackManager: HapticFeedbackManagerProtocol,
        appSettingsManager: AppSettingsManagerProtocol,
        gameSettingsManager: GameSettingsManagerProtocol,
        gameEngineManager: GameEngineManagerProtocol,
        gameHistoryManager: GameHistoryManagerProtocol
    ) {
        self.coordinator = coordinator
        self.hapticFeedbackManager = hapticFeedbackManager
        self.appSettingsManager = appSettingsManager
        self.gameSettingsManager = gameSettingsManager
        self.gameEngineManager = gameEngineManager
        self.gameHistoryManager = gameHistoryManager
        self.snapshotPlayerName = gameSettingsManager.playerName
        self.snapshotDifficulty = gameSettingsManager.difficulty
        self.snapshotGameMode = gameSettingsManager.gameMode
    }
    
    // MARK: - Lifecycle
    
    func onAppear() {
        startTimer()
    }
    
    func onDisappear() {
        stopTimer()
    }
    
    // MARK: - Actions
    
    func handleCellTap(row: Int, column: Int) {
        guard !isPaused && !isGameOver && !isGameWon else { return }
        
        lastTappedRow = row
        lastTappedColumn = column
        
        switch interactionMode {
        case .reveal:
            gameEngineManager.revealCell(row: row, column: column)
            hapticFeedbackManager.impact(style: .light)
        case .flag:
            gameEngineManager.toggleFlag(row: row, column: column)
            hapticFeedbackManager.impact(style: .medium)
        }
        
        checkGameState()
    }
    
    func resetGame() {
        hapticFeedbackManager.notification(type: .warning)
        gameEngineManager.resetGame()
        resetTimer()
        isPaused = false
        didSaveResult = false
        lastTappedRow = nil
        lastTappedColumn = nil
        scale = 1.0
        lastScale = 1.0
        offset = .zero
        lastOffset = .zero
    }
    
    func quitGame() {
        hapticFeedbackManager.notification(type: .error)
        stopTimer()
        coordinator.goBack()
    }
    
    func togglePause() {
        isPaused.toggle()
        hapticFeedbackManager.selection()
        
        if isPaused {
            stopTimer()
        } else {
            resumeTimer()
        }
    }
    
    func setInteractionMode(_ mode: CellInteractionMode) {
        guard interactionMode != mode else { return }
        interactionMode = mode
        hapticFeedbackManager.selection()
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        startTime = Date()
        elapsedTime = 0
        scheduleTimerTask()
    }
    
    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func resumeTimer() {
        startTime = Date().addingTimeInterval(-elapsedTime)
        scheduleTimerTask()
    }
    
    private func resetTimer() {
        stopTimer()
        startTimer()
    }
    
    private func scheduleTimerTask() {
        timerTask?.cancel()
        timerTask = Task { @MainActor [weak self] in
            for await _ in AsyncTimerSequence(interval: .seconds(1), clock: .continuous) {
                guard let self, let startTime = self.startTime else { return }
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    private func checkGameState() {
        if isGameOver {
            stopTimer()
            saveGameResult(won: false)
            hapticFeedbackManager.notification(type: .error)
        } else if isGameWon {
            stopTimer()
            saveGameResult(won: true)
            hapticFeedbackManager.notification(type: .success)
        }
    }
    
    private func saveGameResult(won: Bool) {
        guard !didSaveResult else { return }
        didSaveResult = true
        
        let minesFound = gameEngineManager.totalMines - gameEngineManager.remainingMines
        let triggerRow = won ? nil : lastTappedRow
        let triggerCol = won ? nil : lastTappedColumn
        
        let result = GameResultsModel(
            playerName: snapshotPlayerName,
            time: elapsedTime,
            minesFound: minesFound,
            totalMines: gameEngineManager.totalMines,
            gameWon: won,
            difficulty: snapshotDifficulty,
            gameMode: snapshotGameMode,
            boardWidth: gameEngineManager.columns,
            boardHeight: gameEngineManager.rows,
            finalBoard: gameEngineManager.cells,
            triggerCellRow: triggerRow,
            triggerCellColumn: triggerCol
        )
        gameHistoryManager.saveGame(result)
    }
}
