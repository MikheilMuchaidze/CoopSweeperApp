//
//  Coordinator.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 18.01.26.
//

import Foundation
import Combine

@Observable
final class Coordinator: CoordinatorProtocol {
    // MARK: - Properties

    var path: [NavigationRoutes] = []
    var presentedSheet: NavigationSheets?
    var dismiss: (() -> ())?

    // MARK: - Init

    init() {}

    // MARK: - Navigation Methods

    func navigate(to destination: NavigationRoutes) {
        path.append(destination)
    }

    func present(sheet: NavigationSheets) {
        presentedSheet = sheet
    }

    func popToRoot() {
        path = []
    }

    func goBack() {
        guard !path.isEmpty else {
            return
        }
        path.removeLast()
    }

    func removeLastSafely(_ count: Int = 1) {
        if path.count >= count { path.removeLast(count) }
    }

    func dismissSheet() {
        presentedSheet = nil
    }
}
