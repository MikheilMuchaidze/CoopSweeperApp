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
            AppConstants.mainBackgroundColor
                .overlay(alignment: .top, content: content)
                .navigationBarTitleDisplayMode(.inline)
                .presentationDragIndicator(.visible)
                .scrollDisabled(true) // Disable scroll if empty content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done", action: { dismiss() })
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showingClearConfirmation = true
                        } label: {
                            Label("Clear History", systemImage: "trash")
                        }
                    }
                }
                .alert(
                    "Clear History",
                    isPresented: $showingClearConfirmation,
                    actions: {
                        Button("Clear All", role: .destructive) {
                            // TODO: Delete game history
                        }
                        Button("Cancel", role: .cancel) {
                            showingClearConfirmation = false
                        }
                    },
                    message: {
                        Text("Are you sure you want to clear all game history? This action cannot be undone.")
                    }
                )
        }
    }
}

// MARK: - Body Components

extension GameHistoryView {
    private func content() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .zero) {
                Text("Game History")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                emptyState
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }
        }
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

// MARK: - Preview

#Preview {
    NavigationStack {
        GameHistoryView()
    }
}
