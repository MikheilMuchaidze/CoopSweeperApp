//
//  SettingsViewModel.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import Foundation
import SwiftUI

protocol SettingsViewModelProtocol {
    func dismissView()
}

@Observable
final class SettingsViewModel: SettingsViewModelProtocol {
    // MARK: - Coordinator
    
    private var coordinator: any CoordinatorProtocol

    // MARK: - Private Properties
    
    @ObservationIgnored @Environment(\.dismiss) private var dismiss
    private let appSettingsManager: AppSettingsManagerProtocol
    
    // MARK: - Init
    
    init(
        coordinator: any CoordinatorProtocol,
        appSettingsManager: AppSettingsManagerProtocol
    ) {
        self.coordinator = coordinator
        self.appSettingsManager = appSettingsManager
    }
    
    // MARK: - Methods
    
    func dismissView() {
        coordinator.dismissSheet()
    }
}
