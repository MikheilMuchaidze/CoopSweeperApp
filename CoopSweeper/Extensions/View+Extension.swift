//
//  View+Extension.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 01.03.2026.
//

import SwiftUI

extension View {
    func equalFrame(size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }
    
    @ViewBuilder
    func ifTrue<T, Content: View>(
        _ value: T?,
        transform: (Self, T) -> Content
    ) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
    
    func bottomFadeMask(height: CGFloat = 40) -> some View {
        self.mask(
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.white)

                LinearGradient(
                    colors: [
                        .white,
                        .white.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: height)
            }
        )
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
