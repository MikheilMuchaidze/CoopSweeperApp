//
//  AppSettingsUpdate.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

enum AppSettingsUpdate {
    case sound(isOn: Bool)
    case vibrationEnabled(isOn: Bool)
    case theme(type: AppTheme)
}
