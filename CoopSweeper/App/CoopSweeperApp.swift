//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

import SwiftUI

@main
struct CoopSweeperApp: App {
    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MenuView()
            }
            .frame(minWidth: 400, minHeight: 600)
        }
    }
}
