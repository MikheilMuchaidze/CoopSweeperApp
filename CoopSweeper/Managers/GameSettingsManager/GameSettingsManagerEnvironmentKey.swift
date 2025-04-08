//
//  GameSettingsManagerEnvironmentKey.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import SwiftUI

private struct GameSettingsManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue: GameSettingsManager = DefaultGameSettingsManager()
}

extension EnvironmentValues {
    var gameSettingsManager: GameSettingsManager {
        get { self[GameSettingsManagerEnvironmentKey.self] }
        set { self[GameSettingsManagerEnvironmentKey.self] = newValue }
    }
}
