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
    // Other UI Validation
    @State private var showCustomDifficultySettings = false
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
//            .animation(
//                .easeInOut(duration: 0.3),
//                value: gameSettingsManager.difficulty
//            )
//            .onChange(of: gameSettingsManager.difficulty) { _, newValue in
//                if newValue == .custom {
//                    showCustomDifficultySettings = true
//                } else {
//                    showCustomDifficultySettings = false
//                }
//            }
//            .onChange(of: gameSettingsManager.gameMode) { _, _ in
//                hapticFeedbackManager.impact(style: .soft)
//            }
//            .onChange(of: gameSettingsManager.difficulty) { _, _ in
//                hapticFeedbackManager.impact(style: .soft)
//            }
//            .onChange(of: gameSettingsManager.customWidth) { _, _ in
//                hapticFeedbackManager.impact(style: .soft)
//            }
//            .onChange(of: gameSettingsManager.customHeight) { _, _ in
//                hapticFeedbackManager.impact(style: .soft)
//            }
//            .onChange(of: gameSettingsManager.customMines) { _, _ in
//                hapticFeedbackManager.impact(style: .soft)
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
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 12)
        }
    }
    
    private var playerNameChooser: some View {
        VStack(alignment: .leading, spacing: 15) {
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
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label("Game Mode", systemImage: "person.2.fill")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture(perform: viewModel.presentGameModeHintView)
            }
            
            //            Picker("Select Game Mode", selection: .init(get: {
            //                gameSettingsManager.gameMode
            //            }, set: { newGameModeValue in
            //                gameSettingsManager.updateGameSettings(with: .mode(newGameModeValue))
            //            })) {
            //                ForEach(GameMode.allCases, id: \.self) { gameMode in
            //                    Text(gameMode.rawValue.capitalized)
            //                        .tag(gameMode)
            //                }
            //            }
            //            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(
            Rectangle()
                .fill(Color(uiColor: .systemGray4))
                .cornerRadius(12)
        )
    }
    
    private var gameDifficultyChooser: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label("Difficulty", systemImage: "chart.bar.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture(perform: viewModel.presentGameDifficultyHintView)
            }
            
//            Picker("Select Difficulty", selection: .init(get: {
//                gameSettingsManager.difficulty
//            }, set: { newDifficultyValue in
//                gameSettingsManager.updateGameSettings(with: .difficulty(newDifficultyValue))
//            })) {
//                ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
//                    Text(difficulty.rawValue.capitalized)
//                        .tag(difficulty)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
            
//            if gameSettingsManager.difficulty == .custom {
//                ScrollView {
//                    customDifficultySettings
//                }
//                .scrollDismissesKeyboard(.immediately)
//                .scrollIndicators(.hidden)
//            }
        }
        .padding()
        .background(
            Rectangle()
                .fill(Color(uiColor: .systemGray4))
                .cornerRadius(12)
        )
    }
    
    private var customDifficultySettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Custom Settings")
                .font(.headline)
                .padding(.top, 5)
            
//            HStack {
//                Text("Width:")
//                    .frame(width: 60, alignment: .leading)
//                Stepper("\(gameSettingsManager.customWidth)", value: .init(get: {
//                    gameSettingsManager.customWidth
//                }, set: { newCustomWidth in
//                    gameSettingsManager.updateGameSettings(with: .customWidth(newCustomWidth))
//                }), in: 5...30)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            
//            HStack {
//                Text("Height:")
//                    .frame(width: 60, alignment: .leading)
//                Stepper("\(gameSettingsManager.customHeight)", value: .init(get: {
//                    gameSettingsManager.customHeight
//                }, set: { newCustomHeight in
//                    gameSettingsManager.updateGameSettings(with: .customHeight(newCustomHeight))
//                }), in: 5...30)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            
//            HStack {
//                Text("Mines:")
//                    .frame(width: 60, alignment: .leading)
//                Stepper("\(gameSettingsManager.customMines)", value: .init(get: {
//                    gameSettingsManager.customMines
//                }, set: { newCustomMines in
//                    gameSettingsManager.updateGameSettings(with: .customMines(newCustomMines))
//                }), in: 1...max(1, gameSettingsManager.customWidth * gameSettingsManager.customHeight - 1))
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            
//            Text("Maximum mines: \(max(1, gameSettingsManager.customWidth * gameSettingsManager.customHeight - 1))")
//                .font(.caption)
//                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(8)
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
        .tint(Color.blue)
    }
}

// MARK: - Preview

//#Preview {
//    @Previewable @State var coordinator = Coordinator()
//    NavigationStack(path: $coordinator.navigationPath) {
//        MenuView()
//            .navigationDestination(for: NavigationDestination.self) { destination in
//                coordinator.destinationView(for: destination)
//            }
//    }
//    .sheet(item: $coordinator.presentedSheet) { destination in
//        coordinator.sheetView(for: destination)
//    }
//    .fullScreenCover(item: $coordinator.presentedFullScreenCover) { destination in
//        coordinator.fullScreenCoverView(for: destination)
//    }
//    .environment(\.coordinator, coordinator)
//    .environment(\.appSettingsManager, DefaultAppSettingsManager())
//    .environment(\.gameSettingsManager, DefaultGameSettingsManager())
//    .environment(\.hapticFeedbackManager, DefaultHapticFeedbackManager())
//}
