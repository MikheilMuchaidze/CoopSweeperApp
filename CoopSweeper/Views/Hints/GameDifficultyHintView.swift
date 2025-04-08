import SwiftUI

struct GameDifficultyHintView: View {
    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Game Difficulty Guide")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)
                    
                    difficultySection(
                        title: "Easy",
                        description: "Perfect for beginners! A small board with few mines to help you learn the basics of the game.",
                        icon: "1.circle.fill",
                        color: .green
                    )
                    
                    difficultySection(
                        title: "Medium",
                        description: "A balanced challenge with a medium-sized board and a moderate number of mines.",
                        icon: "2.circle.fill",
                        color: .orange
                    )
                    
                    difficultySection(
                        title: "Hard",
                        description: "For experienced players! A large board with many mines that will test your skills.",
                        icon: "3.circle.fill",
                        color: .red
                    )
                    
                    difficultySection(
                        title: "Custom",
                        description: "Create your own challenge by setting the board size and number of mines. Perfect for tailoring the game to your skill level.",
                        icon: "slider.horizontal.3",
                        color: .blue
                    )
                    
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

extension GameDifficultyHintView {
    private func difficultySection(
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
}

// MARK: - Preview

#Preview {
    GameDifficultyHintView()
} 
