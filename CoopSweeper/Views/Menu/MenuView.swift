//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

struct MenuView: View {
    // MARK: - Private Properties

    // Managers
    @Environment(\.hapticFeedbackManager) var hapticFeedbackManager
    @Environment(\.appSettingsManager) var appSettingsManager
    @Environment(\.gameSettingsManager) var gameSettingsManager
    // Navigation booleans
    @State private var presentCoopHintView = false
    @State private var presentGameDifficultyHintView = false
    @State private var presentSettingsView = false
    @State private var startGame = false
    // Player name validation
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
        VStack(spacing: 0) {
            titleAndSubtitleView
                .padding(.top)
                .padding(.bottom, 20)

            playerNameChooser
                .padding(.horizontal, 20)

            gameModeChooser
                .padding(.top, 10)
                .padding(.horizontal, 20)

            ScrollView {
                gameDifficultyChooser
                    .padding(.top, 10)
                    .padding(.horizontal, 20)

                Spacer()
            }
            .scrollDismissesKeyboard(.immediately)
            .scrollIndicators(.hidden)
            .scrollDisabled(showCustomDifficultySettings ? false : true)

            startGameAndSettingsButton
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .onAppear {
            userNameText = ""
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationDestination(isPresented: $startGame) {
            BoardView()
        }
        .sheet(isPresented: $presentCoopHintView, content: {
            GameModeHintView()
        })
        .sheet(isPresented: $presentGameDifficultyHintView, content: {
            GameDifficultyHintView()
        })
        .sheet(isPresented: $presentSettingsView, content: {
            SettingsView()
                .preferredColorScheme(appSettingsManager.theme.colorScheme)
        })
        .animation(.easeInOut(duration: 0.3), value: gameSettingsManager.difficulty)
        .onChange(of: gameSettingsManager.difficulty) { _, newValue in
            if newValue == .custom {
                showCustomDifficultySettings = true
            } else {
                showCustomDifficultySettings = false
            }
        }
        .onChange(of: gameSettingsManager.gameMode) { _, _ in
            hapticFeedbackManager.impact(style: .soft)
        }
        .onChange(of: gameSettingsManager.difficulty) { _, _ in
            hapticFeedbackManager.impact(style: .soft)
        }
        .onChange(of: gameSettingsManager.customWidth) { _, _ in
            hapticFeedbackManager.impact(style: .soft)
        }
        .onChange(of: gameSettingsManager.customHeight) { _, _ in
            hapticFeedbackManager.impact(style: .soft)
        }
        .onChange(of: gameSettingsManager.customMines) { _, _ in
            hapticFeedbackManager.impact(style: .soft)
        }
    }
}

// MARK: - Body Components

extension MenuView {
    private var titleAndSubtitleView: some View {
        VStack(spacing: 8) {
            Text("CoopSweeper")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.blue)

            Text("Challenge Your Mind 🚀")
                .font(.title3)
                .foregroundColor(.gray)
        }
    }

    private var playerNameChooser: some View {
        VStack(alignment: .leading, spacing: 15) {
            Label("Player Name", systemImage: "person.fill")
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)

            CustomTextFieldWithErrorState(
                text: $userNameText,
                hasError: $userNameHasError,
                placeholder: "Enter your name"
            )
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }

    private var gameModeChooser: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label("Game Mode", systemImage: "person.2.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        hapticFeedbackManager.selection()
                        presentCoopHintView.toggle()
                    }
            }

            Picker("Select Game Mode", selection: .init(get: {
                gameSettingsManager.gameMode
            }, set: { newGameModeValue in
                gameSettingsManager.updateGameSettings(with: .mode(newGameModeValue))
            })) {
                ForEach(GameMode.allCases, id: \.self) { gameMode in
                    Text(gameMode.rawValue.capitalized)
                        .tag(gameMode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
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
                    .onTapGesture {
                        hapticFeedbackManager.selection()
                        presentGameDifficultyHintView.toggle()
                    }
            }

            Picker("Select Difficulty", selection: .init(get: {
                gameSettingsManager.difficulty
            }, set: { newDifficultyValue in
                gameSettingsManager.updateGameSettings(with: .difficulty(newDifficultyValue))
            })) {
                ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.rawValue.capitalized)
                        .tag(difficulty)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            if gameSettingsManager.difficulty == .custom {
                customDifficultySettings
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }

    private var customDifficultySettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Custom Settings")
                .font(.headline)
                .padding(.top, 5)
            
            HStack {
                Text("Width:")
                    .frame(width: 60, alignment: .leading)
                Stepper("\(gameSettingsManager.customWidth)", value: .init(get: {
                    gameSettingsManager.customWidth
                }, set: { newCustomWidth in
                    gameSettingsManager.updateGameSettings(with: .customWidth(newCustomWidth))
                }), in: 5...30)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Height:")
                    .frame(width: 60, alignment: .leading)
                Stepper("\(gameSettingsManager.customHeight)", value: .init(get: {
                    gameSettingsManager.customHeight
                }, set: { newCustomHeight in
                    gameSettingsManager.updateGameSettings(with: .customHeight(newCustomHeight))
                }), in: 5...30)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Mines:")
                    .frame(width: 60, alignment: .leading)
                Stepper("\(gameSettingsManager.customMines)", value: .init(get: {
                    gameSettingsManager.customMines
                }, set: { newCustomMines in
                    gameSettingsManager.updateGameSettings(with: .customMines(newCustomMines))
                }), in: 1...max(1, gameSettingsManager.customWidth * gameSettingsManager.customHeight - 1))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("Maximum mines: \(max(1, gameSettingsManager.customWidth * gameSettingsManager.customHeight - 1))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var startGameButton: some View {
        Button {
            if userNameText.isEmpty {
                userNameHasError = true
                hapticFeedbackManager.notification(type: .error)
                return
            }

            hapticFeedbackManager.notification(type: .success)
            startGame.toggle()
        } label: {
            HStack {
                Text("Start Game")
                    .font(.title3.weight(.semibold))
                Image(systemName: "play.fill")
            }
            .font(.title3)
            .foregroundColor(.white)
            .frame(height: 30)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(15)
            .shadow(color: isDarkModeOn ? .white : .black, radius: 2)
        }
    }

    private var settingsButton: some View {
        Button {
            hapticFeedbackManager.selection()
            presentSettingsView.toggle()
        } label: {
            Image(systemName: "gear")
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .font(.title2)
                .padding()
                .background(Color.blue)
                .cornerRadius(15)
        }
    }

    private var startGameAndSettingsButton: some View {
        HStack {
            startGameButton
            Spacer()
            settingsButton
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MenuView()
            .environment(\.appSettingsManager, DefaultAppSettingsManager())
            .environment(\.hapticFeedbackManager, DefaultHapticFeedbackManager())
    }
}
