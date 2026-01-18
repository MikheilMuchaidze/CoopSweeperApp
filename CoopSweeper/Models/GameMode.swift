//
//  GameMode.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

enum GameMode: String, CaseIterable, Identifiable {
    case local = "Local"
    case coop = "Coop"
    
    var id: String {
        switch self {
        case .local:
            "local"
        case .coop:
            "coop"
        }
    }
}
