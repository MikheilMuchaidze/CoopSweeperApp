//
//  CoordinatorProtocol.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 18.01.2026.
//

protocol CoordinatorProtocol {
    var path: [NavigationRoutes] { get set }
    var presentedSheet: (NavigationSheets)? { get set }
    var dismiss: (() -> ())? { get set }

    func navigate(to destination: NavigationRoutes)
    func present(sheet: NavigationSheets)
    func popToRoot()
    func goBack()
    func removeLastSafely(_ count: Int)
    func dismissSheet()
}
