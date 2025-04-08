//
//  HapticFeedbackManagerEnvironmentKey.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import SwiftUI

private struct HapticFeedbackManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue: HapticFeedbackManager = DefaultHapticFeedbackManager()
}

extension EnvironmentValues {
    var hapticFeedbackManager: HapticFeedbackManager {
        get { self[HapticFeedbackManagerEnvironmentKey.self] }
        set { self[HapticFeedbackManagerEnvironmentKey.self] = newValue }
    }
}
