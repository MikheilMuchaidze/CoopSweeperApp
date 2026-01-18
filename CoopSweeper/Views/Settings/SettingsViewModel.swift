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
    
    func navigateToPrivacyPolices()
    func navigateToTermsAndConditions()
    func navigateToSupport()
    
    func getSoundEffectsSetting() -> Bool
    func updateSoundEffectSetting(with newValue: Bool)
    func getVibrationSetting() -> Bool
    func updateVibrationSetting(with newValue: Bool)
    func getCurrentThemeSetting() -> AppTheme
    func updateCurrentThemeSetting(with newValue: AppTheme)
}

@Observable
final class SettingsViewModel: SettingsViewModelProtocol {
    // MARK: - Coordinator
    
    private var coordinator: any CoordinatorProtocol

    // MARK: - Private Properties
    
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
    
    func navigateToPrivacyPolices() {
        guard
            let privacyAndPoliciesUrl = URL(string: "https://www.example.com/privacy")
        else {
            return
        }
        UIApplication.shared.open(privacyAndPoliciesUrl)
    }
    
    func navigateToTermsAndConditions() {
        guard
            let termsAndConditionsUrl = URL(string: "https://www.example.com/terms")
        else {
            return
        }
        UIApplication.shared.open(termsAndConditionsUrl)

    }
    
    func navigateToSupport() {
        guard
            let supportUrl = URL(string: "https://www.example.com/support")
        else {
            return
        }
        UIApplication.shared.open(supportUrl)
    }
    
    func getSoundEffectsSetting() -> Bool {
        appSettingsManager.soundEnabled
    }
    
    func updateSoundEffectSetting(with newValue: Bool) {
        appSettingsManager.updateSettings(
            with: .sound(
                isOn: newValue
            )
        )
    }
    
    func getVibrationSetting() -> Bool {
        appSettingsManager.vibrationEnabled
    }
    
    func updateVibrationSetting(with newValue: Bool) {
        appSettingsManager.updateSettings(
            with: .vibrationEnabled(
                isOn: newValue
            )
        )
    }
    
    func getCurrentThemeSetting() -> AppTheme {
        appSettingsManager.theme
    }
    
    func updateCurrentThemeSetting(with newValue: AppTheme) {
        appSettingsManager.updateSettings(
            with: .theme(
                type: newValue
            )
        )
    }
}
