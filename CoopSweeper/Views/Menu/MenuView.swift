//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

struct MenuView: View {
    // MARK: - Private Properties

    @StateObject private var settings = GameSettings()
    // Navigation booleans
    @State private var presentCoopHintView = false
    @State private var presentGameDifficultyHintView = false
    @State private var startGame = false
    @State private var showSettings = false
    // Player name validation
    @State private var userNameText: String = ""
    @State private var userNameHasError: Bool? = false
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
                .padding(.top, 20)
                .padding(.horizontal, 20)

            gameDifficultyChooser
                .padding(.top, 20)
                .padding(.horizontal, 20)

            Spacer()

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
            BoardView(
                gameSettings: settings
            )
        }
        .sheet(isPresented: $presentCoopHintView, content: {
            EmptyView()
        })
        .sheet(isPresented: $presentGameDifficultyHintView, content: {
            EmptyView()
        })
        .animation(.easeInOut(duration: 0.3), value: settings.difficulty)
    }
}

// MARK: - Body Components

extension MenuView {
    private var titleAndSubtitleView: some View {
        VStack(spacing: 8) {
            Text("CoopSweeper")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.blue)

            Text("Challenge Your Mind")
                .font(.title3)
                .foregroundColor(.gray)
        }
    }

    private var playerNameChooser: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Player Name")
                .font(.title2)
                .bold()

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

    private var gameDifficultyChooser: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Game Difficulty")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        presentGameDifficultyHintView.toggle()
                    }
            }

            Picker("Select Difficulty", selection: $settings.difficulty) {
                ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.rawValue.capitalized)
                        .tag(difficulty)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            if settings.difficulty == .custom {
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
                Stepper("\(settings.customWidth)", value: $settings.customWidth, in: 5...30)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Height:")
                    .frame(width: 60, alignment: .leading)
                Stepper("\(settings.customHeight)", value: $settings.customHeight, in: 5...30)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Mines:")
                    .frame(width: 60, alignment: .leading)
                Stepper("\(settings.customMines)", value: $settings.customMines, in: 1...max(1, settings.customWidth * settings.customHeight - 1))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("Maximum mines: \(max(1, settings.customWidth * settings.customHeight - 1))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var gameModeChooser: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Coop mode")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        presentCoopHintView.toggle()
                    }
            }

            Picker("Select Game Mode", selection: $settings.gameMode) {
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

    private var startGameButton: some View {
        Button {
            if userNameText.isEmpty {
                userNameHasError = true
                return
            }
            startGame.toggle()
        } label: {
            Text("Start Game")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(15)
                .shadow(color: isDarkModeOn ? .white : .black, radius: 4)
        }
    }

    private var settingsButton: some View {
        Button {
            showSettings.toggle()
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
    }
}
