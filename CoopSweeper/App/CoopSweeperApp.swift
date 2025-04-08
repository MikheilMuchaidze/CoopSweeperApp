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
            }
            .frame(minWidth: 400, minHeight: 600)
            .environment(\.hapticFeedbackManager, hapticFeedbackManager)
            .environment(\.appSettingsManager, appSettingsManager)
        }
    }
}
