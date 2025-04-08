//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

@main
struct CoopSweeperApp: App {
    // MARK: - Private Properties

    @State private var appSettingsManager = DefaultAppSettingsManager()
    private let hapticFeedbackManager = DefaultHapticFeedbackManager()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MenuView()
                    .preferredColorScheme(appSettingsManager.theme.colorScheme)
            }
            .environment(\.hapticFeedbackManager, hapticFeedbackManager)
            .environment(\.appSettingsManager, appSettingsManager)
        }
    }
}
