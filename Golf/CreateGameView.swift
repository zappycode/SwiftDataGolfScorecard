//
//  CreateGameView.swift
//  Golf
//
//  Created by Nick Walter on 6/14/23.
//

import SwiftUI
import SwiftData

struct CreateGameView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query(filter: #Predicate { $0.addToGame == false }) private var players: [Player]
    @Query(filter: #Predicate { $0.addToGame == true }) private var playersForGame: [Player]
    
    @State private var showingCreatePlayerView = false
    @Binding var presentedGame: [Game]
    
    var body: some View {
        NavigationStack {
            List {
                if playersForGame.count > 0 {
                    Section(header: Text("Golfers for this Game")) {
                        ForEach(playersForGame.sorted(by: { player1, player2 in player1.name < player2.name })) { player in
                            NavigationLink(destination: EditPlayerView(player: player)) {
                                Text(player.emojiAndName())
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            let newGame = Game(players: playersForGame)
                            for holeNumber in 1...18 {
                                let hole = Hole(number: holeNumber, game: newGame)
                                for player in newGame.players {
                                    let score = Score(hole: hole, player: player, game: newGame)
                                    modelContext.insert(score)
                                }
                            }
                            presentedGame.append(newGame)
                            dismiss()
                            
                        }) {
                            if playersForGame.count <= 1 {
                                Text("Start Game With 1 Golfer")
                            } else {
                                Text("Start Game With \(playersForGame.count) Golfers")
                            }
                        }
                    }
                }
                
                if players.count > 0 {
                    Section(header: Text("All Golfers")) {
                        ForEach(players.sorted(by: { player1, player2 in player1.name < player2.name })) { player in
                            Button(action: {
                                player.addToGame = true
                            }) {
                                Text(player.emojiAndName())
                                    .foregroundStyle(Color(UIColor.label))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Golfers")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingCreatePlayerView.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreatePlayerView) {
            CreatePlayerView()
        }
        .onDisappear {
            for player in playersForGame {
                player.addToGame = false
            }
        }
    }
}

//#Preview {
//    CreateGameView()
//}
