//
//  BoardViewModel.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 19.01.2026.
//

import Foundation
import Combine

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
    
    private var timer: Timer?
    private var startTime: Date?
    
    // MARK: - Init
    
    init(
        coordinator: any CoordinatorProtocol,
        hapticFeedbackManager: HapticFeedbackManagerProtocol,
        appSettingsManager: AppSettingsManagerProtocol,
        gameSettingsManager: GameSettingsManagerProtocol,
        gameEngineManager: GameEngineManagerProtocol
    ) {
        self.coordinator = coordinator
        self.hapticFeedbackManager = hapticFeedbackManager
        self.appSettingsManager = appSettingsManager
        self.gameSettingsManager = gameSettingsManager
        self.gameEngineManager = gameEngineManager
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resumeTimer() {
        // Adjust start time to account for elapsed time
        startTime = Date().addingTimeInterval(-elapsedTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func resetTimer() {
        stopTimer()
        startTimer()
    }
    
    private func checkGameState() {
        if isGameOver {
            stopTimer()
            hapticFeedbackManager.notification(type: .error)
        } else if isGameWon {
            stopTimer()
            hapticFeedbackManager.notification(type: .success)
        }
    }
}
