//
//  SettingsCard.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 01.03.2026.
//

import SwiftUI

struct SettingsCard<Content: View>: View {
    // MARK: - Private Properties
    
    private let title: String
    private let content: Content
    
    // MARK: - Init
    
    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.5))
            )
        }
        .padding(.horizontal, 16)
    }
}
