//
//  GameHistoryView.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 10.04.25.
//

import SwiftUI

struct GameHistoryView: View {
    // MARK: - Private Properties

    // UI state
    @Environment(\.dismiss) private var dismiss
    @State private var showingClearConfirmation = false
    // Theme
    @Environment(\.colorScheme) var colorScheme
    private var isDarkModeOn: Bool {
        colorScheme == .dark
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                emptyState
                    .padding()
            }
            .navigationTitle("Game History")
            .navigationBarTitleDisplayMode(.large)
            .presentationDragIndicator(.visible)
            .scrollDisabled(true) // Disable scroll if empty content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingClearConfirmation = true
                    } label: {
                        Label("Clear History", systemImage: "trash")
                    }
                }
            }
            .confirmationDialog( "Clear History", isPresented: $showingClearConfirmation, titleVisibility: .visible ) {
                Button("Clear All", role: .destructive) {
                    // TODO: Delete game history
                }
                Button("Cancel", role: .cancel) {

                }
            } message: {
                Text("Are you sure you want to clear all game history? This action cannot be undone.")
            }
        }
    }
}

// MARK: - Body Components

extension GameHistoryView {
    private var emptyState: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .padding(.top, 10)
            Text("No Games Played Yet")
                .font(.title3)
                .bold()
                .padding(.top, 10)
            Text("Your game history will appear here after you complete some games.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .background(
            Rectangle()
                .fill(Color(uiColor: .systemGray5))
                .cornerRadius(12)
                .shadow(
                    color: isDarkModeOn ? .gray : .black, radius: 3
                )
        )
    }
}

// MARK: - Preview

#Preview {
    GameHistoryView()
}

//// pretify this code
//import SwiftUI struct GameHistoryView: View {
//// MARK: - Private Properties
//
//// Managers
//@Environment(\.appSettingsManager) private var appSettingsManager
//@Environment(\.dismiss) private var dismiss
//// Alert state
// @State private var showingClearConfirmation = false
//// Theme
//@Environment(\.colorScheme) var colorScheme
//private var isDarkModeOn: Bool { colorScheme == .dark }
//
//// MARK: - Body
//var body: some View {
//    NavigationStack {
//        ScrollView {
//            VStack(alignment: .center, spacing: 20) {
//                if appSettingsManager.gameHistory.isEmpty {
//                    emptyStateView
//                } else {
//                    ForEach(appSettingsManager.gameHistory) { game in
//                        GameHistoryRow(game: game)
//                    }
//                }
//            }
//            .padding(.top, 20)
//        }
//        .scrollDisabled(appSettingsManager.gameHistory.isEmpty)
//        .navigationTitle("Game History")
//        .navigationBarTitleDisplayMode(.inline)
//        .presentationDragIndicator(.visible)
//        .background(Color(.systemGroupedBackground))
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button {
//                    showingClearConfirmation = true
//                } label: {
//                    Label("Clear History", systemImage: "trash")
//                }
//                .disabled(appSettingsManager.gameHistory.isEmpty)
//            }
//        }
//        .confirmationDialog( "Clear History", isPresented: $showingClearConfirmation, titleVisibility: .visible ) {
//            Button("Clear All", role: .destructive) {
//                appSettingsManager.clearGameHistory()
//            }
//            Button("Cancel", role: .cancel) {
//
//            }
//        } message: {
//            Text("Are you sure you want to clear all game history? This action cannot be undone.")
//        }
//    }
//}
//}
//
//// MARK: - Body Components
//
extension GameHistoryView {
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Games Played Yet")
                .font(.title3)
                .bold()
            Text("Your game history will appear here after you complete some games.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .background(
            Rectangle()
                .fill(Color(uiColor: .systemGray6))
                .cornerRadius(12)
                .shadow( color: isDarkModeOn ? .gray : .black, radius: 3 )
        )
    }
}

//struct GameHistoryRow: View { let game: GameHistoryItem var body: some View { VStack(alignment: .leading, spacing: 8) { HStack { Text(game.playerName) .font(.headline) Spacer() Text(game.date.formatted(date: .abbreviated, time: .shortened)) .font(.caption) .foregroundStyle(.secondary) } HStack { Label(game.gameMode.rawValue, systemImage: game.gameMode == .coop ? "person.2.fill" : "person.fill") .font(.subheadline) Spacer() Label(game.difficulty.rawValue, systemImage: "chart.bar.fill") .font(.subheadline) } HStack { Text("Board: \(game.boardSize)") .font(.caption) .foregroundStyle(.secondary) Spacer() Text("Mines: \(game.mineCount)") .font(.caption) .foregroundStyle(.secondary) } HStack { Text("Duration: \(formatDuration(game.duration))") .font(.caption) .foregroundStyle(.secondary) Spacer() Text(game.result.rawValue.capitalized) .font(.subheadline) .foregroundStyle(game.result == .win ? .green : .red) } } .padding(.vertical, 8) } private func formatDuration(_ duration: TimeInterval) -> String { let minutes = Int(duration) / 60 let seconds = Int(duration) % 60 return String(format: "%02d:%02d", minutes, seconds) } } // MARK: - Preview #Preview { GameHistoryView() }
