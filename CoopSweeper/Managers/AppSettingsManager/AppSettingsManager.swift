//
//  AppSettingsManager.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import SwiftUI

protocol AppSettingsManagerProtocol {
    var soundEnabled: Bool { get }
    var vibrationEnabled: Bool { get }
    var theme: AppTheme { get }
    var longPressDurationMs: Int { get }

    func updateSettings(with update: AppSettingsUpdate)
}

@Observable
final class AppSettingsManager: AppSettingsManagerProtocol {
    // MARK: - Private Properties

    // AppStorage
    @ObservationIgnored @AppStorage("soundEnabled") var soundEnabledFromStorage: Bool = true
    @ObservationIgnored @AppStorage("vibrationEnabled") var vibrationEnabledFromStorage: Bool = true
    @ObservationIgnored @AppStorage("activeTheme") var activeThemeFromStorage: String = AppTheme.system.rawValue
    @ObservationIgnored @AppStorage("longPressDurationMs") var longPressDurationMsFromStorage: Int = 300

    // MARK: - Publised Properties

    var soundEnabled: Bool {
        didSet {
            soundEnabledFromStorage = soundEnabled
        }
    }

    var vibrationEnabled: Bool {
        didSet {
            vibrationEnabledFromStorage = vibrationEnabled
        }
    }

    var theme: AppTheme {
        didSet {
            activeThemeFromStorage = theme.rawValue
        }
    }

    var longPressDurationMs: Int {
        didSet {
            longPressDurationMsFromStorage = longPressDurationMs
        }
    }

    // MARK: - Init

    init(
        soundEnabled: Bool = true,
        vibrationEnabled: Bool = true,
        theme: AppTheme = .system,
        longPressDurationMs: Int = 300
    ) {
        self.soundEnabled = soundEnabled
        self.vibrationEnabled = vibrationEnabled
        self.theme = theme
        self.longPressDurationMs = longPressDurationMs
        updateSettingsWithSavedOnes()
    }

    // MARK: - Private Methods

    private func updateSettingsWithSavedOnes() {
        soundEnabled = soundEnabledFromStorage
        vibrationEnabled = vibrationEnabledFromStorage
        theme = AppTheme(rawValue: activeThemeFromStorage) ?? .system
        longPressDurationMs = longPressDurationMsFromStorage
    }

    // MARK: - Methods

    func updateSettings(with update: AppSettingsUpdate) {
        switch update {
        case let .sound(isOn):
            soundEnabled = isOn
        case let .vibrationEnabled(isOn):
            vibrationEnabled = isOn
        case let .theme(type):
            theme = type
        case let .longPressDuration(milliseconds):
            longPressDurationMs = min(max(milliseconds, 100), 500)
        }
    }
}

extension AppSettingsManager: Equatable {
    static func == (
        lhs: AppSettingsManager,
        rhs: AppSettingsManager
    ) -> Bool {
        lhs.soundEnabled == rhs.soundEnabled
        && lhs.vibrationEnabled == rhs.vibrationEnabled
        && lhs.theme == rhs.theme
        && lhs.longPressDurationMs == rhs.longPressDurationMs
    }
}
