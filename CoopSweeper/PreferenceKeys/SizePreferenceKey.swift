//
//  SizePreferenceKey.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 01.03.2026.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
