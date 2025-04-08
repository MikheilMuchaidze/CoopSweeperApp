import SwiftUI

struct GameModeHintView: View {
    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Game Modes Guide")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)
                    
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
            .navigationBarTitleDisplayMode(.inline)
            .presentationDragIndicator(.visible)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Body Components

extension GameModeHintView {
    private func modeSection(
        title: String,
        description: String,
        icon: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)

                Text(title)
                    .font(.title2)
                    .bold()
            }

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    private var instructionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("How Coop Mode Works")
                .font(.title2)
                .bold()

            Text("1. Players take turns revealing cells on the board")
            Text("2. If a player reveals a mine, the game ends")
            Text("3. The goal is to work together to clear the entire board")
            Text("4. Communication is essential - discuss your strategy!")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview


#Preview {
    GameModeHintView()
} 
