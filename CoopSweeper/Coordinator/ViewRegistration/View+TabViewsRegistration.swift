//
//  View+TabViewsRegistration.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 18.01.26.
//

import SwiftUI

@MainActor
extension View {
    func registerViewsFor<T: NavigationPathProtocol>(navigationPaths: [T]) -> some View {
        ForEach(navigationPaths, id: \.id) { _ in
            navigationDestination(for: T.self) { destination in
                switch destination {
                case let mainNavigationRoutes as NavigationRoutes:
                    switch mainNavigationRoutes {
                    case .gameView:
                        EmptyView()
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}
