//
//  CreateGameView.swift
//  Golf
//
//  Created by Nick Walter on 6/13/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Game.dateCreated, order: .reverse) private var games: [Game]
    @State private var showingCreateGameView = false
    @State private var presentedGame = [Game]() // Don't do this until after showing the first way of just add new game and then people can dismiss
    
    var body: some View {
        NavigationStack(path: $presentedGame) {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        VStack(alignment: .leading) {
                            Text(game.playersAsString())
                                .font(.headline)
                            HStack {
                                Text(game.dateCreated, style: .date)
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                Text(game.playersEmojis())
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteGame)
            }
            .navigationTitle("Golf Scorecard")
            .navigationDestination(for: Game.self) { game in
                GameView(game: game)
            }
            .toolbar {
                Button(action: {
                    showingCreateGameView.toggle()
                }) {
                    Text("New Game")
                }
            }
            .sheet(isPresented: $showingCreateGameView) {
                CreateGameView(presentedGame: $presentedGame)
            }
        }
    }
    
    private func deleteGame(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(games[index])
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    HomeView()
}
