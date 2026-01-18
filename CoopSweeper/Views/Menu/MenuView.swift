//
//  MenuView.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

struct MenuView: View {
    // MARK: - ViewModel
    
    @State private var viewModel: MenuViewModelProtocol
    
    // MARK: - Init
    
    init(
        viewModel: MenuViewModelProtocol
    ) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private Properties
    
    @State private var userNameText: String = ""
    @State private var userNameHasError: Bool? = false
    // Theme
    @Environment(\.colorScheme) var colorScheme
    private var isDarkModeOn: Bool {
        colorScheme == .dark
    }
    
    // MARK: - Body
    
    var body: some View {
        AppConstants.mainBackgroundColor
            .overlay(content: scrollableContent)
            .overlay(alignment: .bottom, content: startGameButton)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    gameHistoryButton
                }
                ToolbarItem(placement: .principal) {
                    Text("CoopSweeper")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    settingsButton
                }
            }
//            .onAppear {
//                userNameText = ""
//                gameSettingsManager.updateGameSettings(with: .playerName(""))
//            }
    }
}

// MARK: - Body Components

extension MenuView {
    private func scrollableContent() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                gameModeChooser
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                                
                gameDifficultyChooser
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 12)
        }
    }
    
    private var playerNameChooser: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Player Name", systemImage: "person.fill")
                .font(.title2.weight(.bold))
                .foregroundStyle(.black)
            
//            CustomTextFieldWithErrorState(
//                text: .init(get: {
//                    gameSettingsManager.playerName
//                }, set: { newName in
//                    gameSettingsManager.updateGameSettings(with: .playerName(newName))
//                }),
//                hasError: $userNameHasError,
//                placeholder: "Enter your name"
//            )
        }
        .padding()
        .background(
            Rectangle()
                .fill(Color(uiColor: .systemGray4))
                .cornerRadius(12)
        )
    }
    
    private var gameModeChooser: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Game Mode", systemImage: "person.2.fill")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture(perform: viewModel.presentGameModeHintView)
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 12) {
                ForEach(viewModel.gameModes, id: \.id) { gameMode in
                    GameModeButton(
                        mode: gameMode,
                        isSelected: viewModel.selectedGameMode == gameMode,
                        action: { viewModel.updateGameMode(with: gameMode) }
                    )
                }
            }
            .padding(.top, 12)
        }
        .animation(
            .easeInOut(duration: 0.3),
            value: viewModel.selectedGameMode
        )
    }
    
    private var gameDifficultyChooser: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Difficulty", systemImage: "chart.bar.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture(perform: viewModel.presentGameDifficultyHintView)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(viewModel.gameDifficulties, id: \.id) { difficulty in
                    DifficultyButton(
                        difficulty: difficulty,
                        isSelected: viewModel.selectedGameDifficulty == difficulty,
                        action: { viewModel.updateGameDifficulty(with: difficulty) }
                    )
                }
            }
            .padding(.top, 12)
                        
            if viewModel.selectedGameDifficulty == .custom {
                customDifficultySettings
                    .scrollDismissesKeyboard(.immediately)
                    .scrollIndicators(.hidden)
                    .padding(.top, 2)
            }
        }
        .animation(
            .easeInOut(duration: 0.3),
            value: viewModel.selectedGameMode
        )
    }
    
    private var customDifficultySettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Custom Settings")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 4)
            
            HStack {
                Text("Width:")
                    .frame(width: 60, alignment: .leading)
                    .foregroundColor(.white)
                Stepper("\(viewModel.selectedCustomWidthForBoard)", value: .init(get: {
                    viewModel.selectedCustomWidthForBoard
                }, set: { newCustomWidth in
                    viewModel.updateCustomGameWidth(with: newCustomWidth)
                }), in: 5...30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
            }
            
            HStack {
                Text("Height:")
                    .frame(width: 60, alignment: .leading)
                    .foregroundColor(.white)
                Stepper("\(viewModel.selectedCustomHeightForBoard)", value: .init(get: {
                    viewModel.selectedCustomHeightForBoard
                }, set: { newCustomHeight in
                    viewModel.updateCustomGameHeight(with: newCustomHeight)
                }), in: 5...30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
            }
            
            HStack {
                Text("Mines:")
                    .frame(width: 60, alignment: .leading)
                    .foregroundColor(.white)
                Stepper("\(viewModel.selectedCustomMinesForBoard)", value: .init(get: {
                    viewModel.selectedCustomMinesForBoard
                }, set: { newCustomMines in
                    viewModel.updateCustomGameMines(with: newCustomMines)
                }), in: 1...max(1, viewModel.selectedCustomWidthForBoard * viewModel.selectedCustomHeightForBoard - 1))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
            }
            
            Text("Maximum mines: \(max(1, viewModel.selectedCustomWidthForBoard * viewModel.selectedCustomHeightForBoard - 1))")
                .foregroundColor(.white)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    Color(red: 0.3, green: 0.7, blue: 0.9),
                    lineWidth: 2
                )
        )
    }
    
    private var asd: some View {
        Label("asdasd", image: "a")
    }
    
    private func startGameButton() -> some View {
        Button {
            if false {
//            if gameSettingsManager.playerName.isEmpty {
                userNameHasError = true
//                hapticFeedbackManager.notification(type: .error)
                return
            }
            
//            hapticFeedbackManager.notification(type: .success)
//            let gameEngine = DefaultGameEngineManager(
//                rows: gameSettingsManager.boardHeight,
//                columns: gameSettingsManager.boardWidth,
//                totalMines: gameSettingsManager.mineCount
//            )
//            coordinator.push(.board(gameEngineManager: gameEngine))
        } label: {
            HStack {
                Text("Start Game")
                    .font(.title3.weight(.semibold))
                Image(systemName: "play.fill")
            }
            .frame(height: 36)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .buttonStyle(.glassProminent)
        .tint(.blue)
        .shadow(
            color: Color(
                red: 0.3,
                green: 0.7,
                blue: 0.9
            ).opacity(0.5),
            radius: 20,
            x: 0,
            y: 8
        )
    }
    
    private var gameHistoryButton: some View {
        Button(action: viewModel.presentGameHistoryView) {
            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                .frame(width: 44, height: 44)
                .foregroundColor(.white)
                .font(.title2)
        }
        .buttonStyle(.glassProminent)
        .tint(Color(uiColor: .systemGray4))
    }
    
    private var settingsButton: some View {
        Button(action: viewModel.presentSettingsView) {
            Image(systemName: "gear")
                .frame(width: 44, height: 44)
                .foregroundColor(.white)
                .font(.title2)
        }
        .buttonStyle(.glassProminent)
        .tint(Color.brown)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        let viewModel = MenuViewModel(
            coordinator: Coordinator(),
            hapticFeedbackManager: HapticFeedbackManager(),
            appSettingsManager: AppSettingsManager(),
            gameSettingsManager: GameSettingsManager()
        )
        MenuView(viewModel: viewModel)
    }
}
