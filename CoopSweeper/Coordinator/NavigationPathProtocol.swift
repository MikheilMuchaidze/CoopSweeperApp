//
//  NavigationPathProtocol.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

import Foundation

protocol NavigationPathProtocol: Hashable, Identifiable, CaseIterable {}

extension NavigationPathProtocol {
    var navigationId: String {
        String(describing: self).components(
            separatedBy: "("
        ).first ?? String(describing: self)
    }
}

extension NavigationPathProtocol {
    static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.navigationId == rhs.navigationId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
