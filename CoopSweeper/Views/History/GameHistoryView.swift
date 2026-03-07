//
//  GameHistoryView.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 10.04.25.
//

import SwiftUI

struct GameHistoryView: View {
    // MARK: - ViewModel

    @State private var viewModel: GameHistoryViewModelProtocol

    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss
    @State private var showingClearConfirmation = false
    @State private var selectedGame: GameResultsModel?
    @Environment(\.colorScheme) var colorScheme
    private var isDarkModeOn: Bool {
        colorScheme == .dark
    }

    // MARK: - Init

    init(viewModel: GameHistoryViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            AppConstants.mainBackgroundColor
                .overlay(alignment: .top, content: content)
                .navigationBarTitleDisplayMode(.inline)
                .presentationDragIndicator(.visible)
                .toolbar(content: toolbarContent)
                .alert(
                    "Clear History",
                    isPresented: $showingClearConfirmation,
                    actions: {
                        Button("Clear All", role: .destructive) {
                            viewModel.clearHistory()
                        }
                        Button("Cancel", role: .cancel) {
                            showingClearConfirmation = false
                        }
                    },
                    message: {
                        Text("Are you sure you want to clear all game history? This action cannot be undone.")
                    }
                )
                .sheet(item: $selectedGame) { game in
                    NavigationStack {
                        GameHistoryDetailView(game: game)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Done") { selectedGame = nil }
                                }
                            }
                    }
                    .presentationDragIndicator(.visible)
                }
        }
    }
}

// MARK: - Body Components

extension GameHistoryView {
    private func content() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Game History")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                    .padding(.horizontal, 20)

                if viewModel.hasGames {
                    sectionPicker
                        .padding(.horizontal, 20)

                    currentSectionContent
                        .padding(.horizontal, 20)
                } else {
                    emptyState
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Section Picker

extension GameHistoryView {
    private var sectionPicker: some View {
        HStack(spacing: 0) {
            ForEach(HistorySection.allCases, id: \.rawValue) { section in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedSection = section
                    }
                } label: {
                    Text(section.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(viewModel.selectedSection == section ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    viewModel.selectedSection == section
                                    ? Color.blue.opacity(0.8)
                                    : Color.clear
                                )
                        )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Section Content

extension GameHistoryView {
    @ViewBuilder
    private var currentSectionContent: some View {
        switch viewModel.selectedSection {
        case .recent:
            recentSection
        case .difficulty:
            difficultySection
        case .gameMode:
            gameModeSection
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Recent Games", subtitle: "Last 10 games")

            if viewModel.recentGames.isEmpty {
                sectionEmptyState(message: "No recent games yet.")
            } else {
                gamesList(viewModel.recentGames)
            }
        }
    }

    private var difficultySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            difficultyFilter

            let games = viewModel.filteredByDifficulty
            if games.isEmpty {
                sectionEmptyState(
                    message: "No \(viewModel.selectedDifficulty.rawValue.lowercased()) games yet."
                )
            } else {
                sectionHeader(
                    title: "\(viewModel.selectedDifficulty.rawValue) Games",
                    subtitle: "\(games.count) game\(games.count == 1 ? "" : "s")"
                )
                gamesList(games)
            }
        }
    }

    private var gameModeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            modeFilter

            let games = viewModel.filteredByMode
            if games.isEmpty {
                sectionEmptyState(
                    message: "No \(viewModel.selectedMode.rawValue.lowercased()) games yet."
                )
            } else {
                sectionHeader(
                    title: "\(viewModel.selectedMode.rawValue) Games",
                    subtitle: "\(games.count) game\(games.count == 1 ? "" : "s")"
                )
                gamesList(games)
            }
        }
    }
}

// MARK: - Filters

extension GameHistoryView {
    private var difficultyFilter: some View {
        HStack(spacing: 8) {
            ForEach(GameDifficulty.allCases, id: \.rawValue) { difficulty in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedDifficulty = difficulty
                    }
                } label: {
                    Text(difficulty.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(
                            viewModel.selectedDifficulty == difficulty ? .white : .gray
                        )
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(
                                    viewModel.selectedDifficulty == difficulty
                                    ? Color.blue.opacity(0.7)
                                    : Color.white.opacity(0.08)
                                )
                        )
                }
            }
        }
    }

    private var modeFilter: some View {
        HStack(spacing: 8) {
            ForEach(GameMode.allCases, id: \.rawValue) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedMode = mode
                    }
                } label: {
                    Text(mode.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(
                            viewModel.selectedMode == mode ? .white : .gray
                        )
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(
                                    viewModel.selectedMode == mode
                                    ? Color.blue.opacity(0.7)
                                    : Color.white.opacity(0.08)
                                )
                        )
                }
            }
        }
    }
}

// MARK: - Shared Components

extension GameHistoryView {
    private func sectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.5))
        }
    }

    private func gamesList(_ games: [GameResultsModel]) -> some View {
        LazyVStack(spacing: 10) {
            ForEach(games) { game in
                GameHistoryItemView(game: game)
                    .contentShape(Rectangle())
                    .onTapGesture { selectedGame = game }
            }
        }
    }

    private func sectionEmptyState(message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(.white.opacity(0.3))
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var emptyState: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundStyle(.white)
                .padding(.top, 10)
            Text("No Games Played Yet")
                .font(.title3)
                .foregroundStyle(.white)
                .bold()
                .padding(.top, 10)
            Text("Your game history will appear here after you complete some games.")
                .font(.subheadline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .background(
            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.5))
                .cornerRadius(12)
                .shadow(
                    color: isDarkModeOn ? .gray : .black, radius: 3
                )
        )
    }
}

// MARK: - Toolbar Content

extension GameHistoryView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Done", action: { dismiss() })
        }
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showingClearConfirmation = true
            } label: {
                Label("Clear History", systemImage: "trash")
            }
            .disabled(!viewModel.hasGames)
        }
    }
}

// MARK: - Preview

#Preview {
    let viewModel = GameHistoryViewModel(
        gameHistoryManager: GameHistoryManager()
    )
    GameHistoryView(viewModel: viewModel)
}
