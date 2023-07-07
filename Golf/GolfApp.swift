//
//  GolfApp.swift
//  Golf
//
//  Created by Nick Walter on 6/13/23.
//

import SwiftUI
import SwiftData

@main
struct GolfApp: App {

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Game.self, Player.self, Hole.self, Score.self])
    }
}
