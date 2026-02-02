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
    
    init(viewModel: BoardViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        AppConstants.mainBackgroundColor
            .overlay(content: mainContent)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear(perform: viewModel.onAppear)
            .onDisappear(perform: viewModel.onDisappear)
            .overlay(alignment: .center) {
                if viewModel.isPaused {
                    pauseOverlay
                }
            }
            .overlay(alignment: .center) {
                if viewModel.isGameOver || viewModel.isGameWon {
                    gameEndOverlay
                }
            }
    }
}

// MARK: - Main Content

extension BoardView {
    private func mainContent() -> some View {
        VStack(spacing: 0) {
            // Top Stats Bar
            topStatsBar
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
            
            // Game Board
            boardSection
            
            Spacer()
            
            // Bottom Actions
            bottomActionsSection
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
    }
}

// MARK: - Top Stats Bar

extension BoardView {
    private var topStatsBar: some View {
        HStack(spacing: 16) {
            // Mines Counter
            StatCard(
                icon: "asterisk",
                title: "Mines",
                value: "\(viewModel.remainingMines)"
            )
            
            // Timer
            StatCard(
                icon: "stopwatch",
                title: "Time",
                value: viewModel.formattedTime
            )
            
            // Pause Button
            Button(action: viewModel.togglePause) {
                Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
            }
            .buttonStyle(.glassProminent)
            .tint(Color(red: 0.3, green: 0.4, blue: 0.5))
        }
    }
}

// MARK: - Board Section

extension BoardView {
    private var boardSection: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                boardContent
                    .scaleEffect(viewModel.scale, anchor: .center)
                    .offset(viewModel.offset)
                    .frame(
                        minWidth: geometry.size.width,
                        minHeight: geometry.size.height
                    )
            }
            .simultaneousGesture(magnificationGesture)
            .simultaneousGesture(dragGesture)
            .disabled(viewModel.isPaused || viewModel.isGameOver || viewModel.isGameWon)
        }
        .padding(.horizontal, 8)
    }
    
    private var boardContent: some View {
        VStack(spacing: 2) {
            ForEach(0..<viewModel.rows, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<viewModel.columns, id: \.self) { column in
                        BoardCellView(
                            cellConfig: viewModel.cells[row][column],
                            size: viewModel.cellSize
                        )
                        .onTapGesture {
                            viewModel.handleCellTap(row: row, column: column)
                        }
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
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / viewModel.lastScale
                viewModel.lastScale = value
                viewModel.scale = min(max(0.5, viewModel.scale * delta), 3.0)
            }
            .onEnded { _ in
                viewModel.lastScale = 1.0
            }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.offset = CGSize(
                    width: viewModel.lastOffset.width + value.translation.width,
                    height: viewModel.lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                viewModel.lastOffset = viewModel.offset
            }
    }
}

// MARK: - Bottom Actions

extension BoardView {
    private var bottomActionsSection: some View {
        VStack(spacing: 16) {
            // Mode Selector
            interactionModeSelector
            
            // Action Buttons
            HStack(spacing: 12) {
                // Reset Button
                Button(action: viewModel.resetGame) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(Color(red: 0.3, green: 0.5, blue: 0.7))
                
                // Quit Button
                Button(action: viewModel.quitGame) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle")
                        Text("Quit")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(Color(red: 0.7, green: 0.3, blue: 0.3))
            }
        }
    }
    
    private var interactionModeSelector: some View {
        HStack(spacing: 0) {
            ForEach(CellInteractionMode.allCases, id: \.rawValue) { mode in
                Button {
                    viewModel.setInteractionMode(mode)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: mode.iconName)
                        Text(mode.rawValue)
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(viewModel.interactionMode == mode ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                viewModel.interactionMode == mode
                                ? Color.blue.opacity(0.8)
                                : Color.clear
                            )
                    )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Overlays

extension BoardView {
    private var pauseOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color(red: 0.3, green: 0.7, blue: 0.9))
                
                Text("PAUSED")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(4)
                
                Button {
                    viewModel.togglePause()
                } label: {
                    Text("Resume")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 160, height: 50)
                }
                .buttonStyle(.glassProminent)
                .tint(.blue)
            }
        }
    }
    
    private var gameEndOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Icon
                Image(systemName: viewModel.isGameWon ? "trophy.fill" : "burst.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        viewModel.isGameWon
                        ? Color.yellow
                        : Color.red
                    )
                
                // Title
                Text(viewModel.isGameWon ? "YOU WON!" : "GAME OVER")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(2)
                
                // Stats
                VStack(spacing: 8) {
                    Text("Time: \(viewModel.formattedTime)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Mines: \(viewModel.totalMines - viewModel.remainingMines)/\(viewModel.totalMines)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Buttons
                VStack(spacing: 12) {
                    Button {
                        viewModel.resetGame()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Play Again")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 200, height: 50)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.blue)
                    
                    Button {
                        viewModel.quitGame()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "house.fill")
                            Text("Main Menu")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 200, height: 50)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color(red: 0.4, green: 0.4, blue: 0.5))
                }
            }
        }
    }
}

// MARK: - Stat Card

private struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            // Value
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    let viewModel = BoardViewModel(
        coordinator: Coordinator(),
        hapticFeedbackManager: HapticFeedbackManager(),
        appSettingsManager: AppSettingsManager(),
        gameSettingsManager: GameSettingsManager(),
        gameEngineManager: GameEngineManager(rows: 9, columns: 9, totalMines: 10)
    )
    BoardView(viewModel: viewModel)
}
