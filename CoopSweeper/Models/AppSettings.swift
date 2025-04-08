//
//  AppSettings.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import Foundation

final class AppSettings: ObservableObject {
    // MARK: - Published Properties

    @Published var soundEnabled: Bool = true
    @Published var vibrationEnabled: Bool = true
    @Published var darkMode: Bool = false
    @Published var theme: AppTheme = .system {
        didSet {
            print(theme.rawValue)
        }
    }
}

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}
