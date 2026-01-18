//
//  NavigationRoutes.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import Foundation

enum NavigationRoutes: NavigationPathProtocol {
    case gameView

    var id: String {
        switch self {
        case .gameView:
            "gameView"
        }
    }
}
