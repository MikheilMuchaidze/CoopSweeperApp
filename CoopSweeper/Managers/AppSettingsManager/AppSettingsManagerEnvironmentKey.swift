//
//  AppSettingsManagerEnvironmentKey.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import SwiftUI

private struct AppSettingsManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppSettingsManager = DefaultAppSettingsManager()
}

extension EnvironmentValues {
    var appSettingsManager: AppSettingsManager {
        get { self[AppSettingsManagerEnvironmentKey.self] }
        set { self[AppSettingsManagerEnvironmentKey.self] = newValue }
    }
}
