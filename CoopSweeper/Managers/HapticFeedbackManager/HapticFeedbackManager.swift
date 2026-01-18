//
//  HapticFeedbackManager.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import SwiftUI

protocol HapticFeedbackManagerProtocol {
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType)
    func selection()
}

struct HapticFeedbackManager: HapticFeedbackManagerProtocol {
    // MARK: - Feedback Generators

    private let generatorImpact = UIImpactFeedbackGenerator()
    private let generatorNotification = UINotificationFeedbackGenerator()
    private let generatorSelection = UISelectionFeedbackGenerator()

    // Stored properties from settings in userdefaults
    @AppStorage("vibrationEnabled") var vibrationEnabledFromStorage: Bool = true

    // MARK: - Public Functions

    /// Generates impact feedback (light, medium, heavy, rigid, soft)
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard vibrationEnabledFromStorage == true else { return }

        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    /// Generates notification feedback (success, warning, error)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        guard vibrationEnabledFromStorage == true else { return }

        generatorNotification.prepare()
        generatorNotification.notificationOccurred(type)
    }

    /// Generates selection feedback (used for changing selection states)
    func selection() {
        guard vibrationEnabledFromStorage == true else { return }

        generatorSelection.prepare()
        generatorSelection.selectionChanged()
    }}
