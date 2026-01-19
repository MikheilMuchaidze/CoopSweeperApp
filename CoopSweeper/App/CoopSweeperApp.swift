//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

@main
struct CoopSweeperApp: App {
    // MARK: - Coordinator

    @State private var coordinator = Coordinator()
    
    // MARK: - Init
    
    init() {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                MenuViewConfigurator.configureView(
                    coordinator: coordinator
                )
                    .registerViewsFor(navigationPaths: NavigationRoutes.allCases)
                    .registerSheetViewsFor(sheetDestinations: $coordinator.presentedSheet)
            }
        }
    }
}
