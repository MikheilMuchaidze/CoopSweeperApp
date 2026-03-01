//
//  SettingsRow.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 01.03.2026.
//

import SwiftUI

struct SettingsRow<RightView: View>: View {
    // MARK: - Private Properties
    
    private let title: String
    private let titleColor: Color?
    private let right: RightView
    
    // MARK: - Init
    
    init(
        title: String,
        titleColor: Color? = .white,
        @ViewBuilder right: () -> RightView
    ) {
        self.title = title
        self.titleColor = titleColor
        self.right = right()
    }
    
    // MARK: - Body

    var body: some View {
        HStack {
            Text(title)
                .ifTrue(titleColor) { view, titleColor in
                    view
                        .foregroundStyle(titleColor)
                }
            Spacer()
            right
        }
        .padding()
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.leading)
        }
    }
}
