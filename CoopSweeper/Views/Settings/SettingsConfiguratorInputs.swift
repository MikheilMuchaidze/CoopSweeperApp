//
//  SettingsConfiguratorInputs.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import Foundation

struct SettingsConfiguratorInputs {
    // MARK: - Properties
    
    let coordinator: any CoordinatorProtocol
    let appSettingsManager: AppSettingsManagerProtocol
    
    // MARK: - Init
    
    init(
        coordinator: any CoordinatorProtocol,
        appSettingsManager: AppSettingsManagerProtocol
    ) {
        self.coordinator = coordinator
        self.appSettingsManager = appSettingsManager
    }
}
