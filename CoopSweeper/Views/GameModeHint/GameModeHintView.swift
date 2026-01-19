import SwiftUI

struct GameModeHintView: View {
    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content()
                .navigationBarTitleDisplayMode(.inline)
                .presentationDragIndicator(.visible)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done", action: { dismiss() })
                    }
                }
        }
    }
}

// MARK: - Body Components

extension GameModeHintView {
    private func content() -> some View {
        AppConstants.mainBackgroundColor
            .overlay(content: scrollableContent)
    }
    
    private func scrollableContent() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Label("Game Modes Guide", systemImage: "chart.bar.fill")
                    .foregroundStyle(Color(red: 0.3, green: 0.7, blue: 0.9))
                    .font(.title.bold())

                modeSection(
                    title: "Local Mode",
                    description: "Play on your own device. Challenge yourself to clear the board without hitting any mines. Perfect for solo play and improving your skills.",
                    icon: "person.fill",
                    color: .blue
                )
                
                modeSection(
                    title: "Coop Mode",
                    description: "Play with friends! Take turns revealing cells and work together to clear the board. Communication and teamwork are key to success in this mode.",
                    icon: "person.2.fill",
                    color: .green
                )

                instructionView

                Spacer()
            }
            .padding()
        }
    }
    
    private func modeSection(
        title: String,
        description: String,
        icon: String,
        color: Color
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(color)

                    Text(title)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .bold()
                }

                Text(description)
                    .font(.body)
                    .foregroundStyle(.white)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(12)
    }

    private var instructionView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("How Coop Mode Works")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .bold()

                Text("1. Players take turns revealing cells on the board")
                    .foregroundStyle(.white)
                Text("2. If a player reveals a mine, the game ends")
                    .foregroundStyle(.white)
                Text("3. The goal is to work together to clear the entire board")
                    .foregroundStyle(.white)
                Text("4. Communication is essential - discuss your strategy!")
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Preview


#Preview {
    GameModeHintView()
}
