//
//  AppConstants.swift
//  CoopSweeper
//
//  Created by MikheilMuchaidze on 11.01.2026.
//

import SwiftUI

enum AppConstants {
    static var mainBackgroundColor: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.25, blue: 0.30),
                    Color(red: 0.08, green: 0.15, blue: 0.20),
                    Color(red: 0.05, green: 0.10, blue: 0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            RadialGradient(
                colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.5).opacity(0.3),
                    .clear
                ],
                center: .topTrailing,
                startRadius: 100,
                endRadius: 400
            )
        }
        .ignoresSafeArea()
    }

//    struct BackgroundGradientView: View {
//        var body: some View {
//            LinearGradient(
//                colors: [
//                    Color(red: 0.15, green: 0.25, blue: 0.30),
//                    Color(red: 0.08, green: 0.15, blue: 0.20),
//                    Color(red: 0.05, green: 0.10, blue: 0.15)
//                ],
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .overlay(
//                RadialGradient(
//                    colors: [
//                        Color(red: 0.2, green: 0.4, blue: 0.5).opacity(0.3),
//                        Color.clear
//                    ],
//                    center: .topTrailing,
//                    startRadius: 100,
//                    endRadius: 400
//                )
//            )
//        }
//    }
}
