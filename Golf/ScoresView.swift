//
//  ScoresView.swift
//  Golf
//
//  Created by Nick Walter on 7/1/23.
//

import SwiftUI

struct ScoresView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var game: Game
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(game.players.sorted(by: { player1, player2 in player1.totalScoreForGame(game: game) < player2.totalScoreForGame(game: game) })) { player in
                    Text("\(rank(player:player)) \(player.emojiAndName()) - \(player.totalScoreForGame(game: game))")
                }
            }
            .navigationTitle("Scores")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
    
    func rank(player: Player) -> String {
        let rankedPlayers = game.players.sorted(by: { player1, player2 in player1.totalScoreForGame(game: game) < player2.totalScoreForGame(game: game) })
        if let index = rankedPlayers.firstIndex(of: player) {
            let rank = index + 1
            if rank == 1 {
                return "🥇"
            } else if rank == 2 {
                return "🥈"
            } else if rank == 3 {
                return "🥉"
            } else {
                return "\(rank)."
            }
        }
        return "⚠️ ERROR"
    }
}
