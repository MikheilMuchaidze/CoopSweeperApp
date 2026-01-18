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
//        WindowGroup {
//            NavigationStack(path: $coordinator.navigationPath) {
//                MenuView()
//                    .preferredColorScheme(appSettingsManager.theme.colorScheme)
////                    .navigationDestination(for: NavigationDestination.self) { destination in
////                        coordinator.destinationView(for: destination)
////                    }
//            }
////            .sheet(item: $coordinator.presentedSheet) { destination in
////                coordinator.sheetView(for: destination)
////            }
////            .fullScreenCover(item: $coordinator.presentedFullScreenCover) { destination in
////                coordinator.fullScreenCoverView(for: destination)
////            }
    }
}
