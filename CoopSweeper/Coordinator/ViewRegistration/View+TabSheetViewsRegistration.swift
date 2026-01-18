//
//  View+TabSheetViewsRegistration.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 18.01.26.
//

import SwiftUI

//@MainActor
//extension View {
//    func registerSheetViewsFor<T: NavigationPathProtocol>(sheetDestinations: Binding<T?>) -> some View {
//        sheet(item: sheetDestinations) { destination in
//            let sheetPage: AnyView = switch destination {
//            case let mainNavigationSheets as NavigationSheets:
//                switch mainNavigationSheets {
//                case .groupDetails:
//                    AnyView(EmptyView())
//                }
//            default:
//                AnyView(EmptyView())
//            }
//            
//            return sheetPage
//                .presentationDragIndicator(.visible)
//        }
//    }
//}

@MainActor
extension View {
    func registerSheetViewsFor<T: NavigationPathProtocol>(
        sheetDestinations: Binding<T?>
    ) -> some View {
        sheet(item: sheetDestinations) { destination in
            switch destination {

            case let mainNavigationSheets as NavigationSheets:
                switch mainNavigationSheets {
                case .gameModeHintView:
                    GameModeHintView()
                case .gameDifficultyHintView:
                    GameDifficultyHintView()
                case let .settingsView(input: settingsViewInputs):
                    EmptyView()
                    SettingsViewConfigurator.configureView(
                        viewInputs: settingsViewInputs
                    )
                case .gameHistoryView:
                    GameHistoryView()
                }

            default:
                EmptyView()
            }
        }
        .presentationDragIndicator(.visible)
    }
}
