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
    @State private var startGame = false
    @State private var showSettings = false
    @State private var showClearHistoryAlert = false
    @State private var nameTextfieldEmpty = true

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

            gameHistorySection
                .padding(.top, 20)
                .padding(.horizontal, 20)

            Spacer()

            startGameAndSettingsButton
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
        .navigationDestination(isPresented: $startGame) {
            BoardView(
                gameSettings: settings
            )
        }
        .alert(
            "Clear History",
            isPresented: $showClearHistoryAlert
        ) {
            Button(
                "Cancel",
                role: .cancel
            ) { }
            Button(
                "Clear",
                role: .destructive
            ) {
                // TODO: Remove history
            }
        } message: {
            Text("Are you sure you want to clear all game history?")
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

            TextField("Enter your name", text: $settings.playerName)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: 4)
                        .cornerRadius(5)
                }
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
            }

            Picker("Select Difficulty", selection: $settings.difficulty) {
                ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.rawValue.capitalized)
                        .tag(difficulty)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
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

    private var gameHistorySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Games")
                    .font(.title2)
                    .bold()
                Spacer()
                Button {
                    showClearHistoryAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }

            if true {
                Text("No games played yet")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                // TODO: Add history rows
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }

    private var startGameButton: some View {
        Button {
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
                .shadow(radius: 5)
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
