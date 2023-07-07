//
//  Item.swift
//  Golf
//
//  Created by Nick Walter on 6/13/23.
//

import Foundation
import SwiftData

@Model
final class Game {
    var dateCreated: Date
    
    @Relationship(.noAction, inverse: \Player.games)
    var players: [Player]
    
    @Relationship(.cascade, inverse: \Hole.game)
    var holes: [Hole]
    
    init(players: [Player]) {
        self.players = players
        self.dateCreated = Date()
    }
    
    func scoreFor(hole: Hole, player: Player) -> Score? {
        let scores = player.scores.filter { score in
            score.hole == hole
        }
        return scores.first
    }
    
    func playersAsString() -> String {
        var playersString = ""
        for player in players.sorted(by: { player1, player2 in player1.name < player2.name }) {
            if player == players.sorted(by: { player1, player2 in player1.name < player2.name }).last {
                playersString += player.name
            } else {
                playersString += "\(player.name), "
            }
        }
        return playersString
    }
    
    func playersEmojis() -> String {
        var emojisString = ""
        for player in players.sorted(by: { player1, player2 in player1.name < player2.name }) {
            emojisString += player.emoji
        }
        return emojisString
    }
}

@Model
final class Player {
    var name: String
    var emoji: String
    
    var games: [Game]
    
    var addToGame: Bool
    
    @Relationship(.cascade, inverse: \Score.player)
    var scores: [Score]
    
    init(name: String, addToGame: Bool = false) {
        self.name = name
        self.emoji = randomEmoji()
        self.addToGame = addToGame
    }
    
    func emojiAndName() -> String {
        return "\(self.emoji) \(self.name)"
    }
    
    func randomEmoji() -> String {
        // Use this as a teaching moment
        // I searched: swift get random emoji
        // and adapted this: https://stackoverflow.com/questions/52007286/show-random-emoji-inside-a-label-in-tableviewcell
        
        if let randoElement = Array(0x1F300...0x1F3F0).randomElement() {
            if let scalar = UnicodeScalar(randoElement) {
                return String(scalar)
            }
        }
        
        return "🏎️"
    }
    
    func scoreFor(hole: Hole) -> Score? {
        let scores = self.scores.filter { score in
            score.hole == hole
        }
        if scores.count > 0 {
            return scores.first
        }
        // IF YOU GET HERE, YOU GOT BIG PROBLEMS BUD
        return nil
    }
    
    func totalScoreForGame(game: Game) -> Int {
        let playerScores = self.scores.filter { score in
            score.game == game
        }
        
        var total = 0
        for score in playerScores {
            total += score.score
        }
        
        return total
    }
    
    func strokesBehindString(game: Game) -> String {
        if let topPlayer = game.players.sorted(by: { player1, player2 in player1.totalScoreForGame(game: game) < player2.totalScoreForGame(game: game) }).first {
            if self.totalScoreForGame(game: game) == topPlayer.totalScoreForGame(game: game) {
                return "👑 Leader"
            } else {
                let diff = self.totalScoreForGame(game: game) - topPlayer.totalScoreForGame(game: game)
                return "\(diff) Strokes Behind"
            }
        }
        return "⚠️ ERROR"
    }
}

@Model
final class Hole {
    var game: Game? // Idk why this has to be optional. Remove and it complains about objects being in different contexts
    var number: Int
    
    init(number: Int, game: Game) {
        self.number = number
        self.game = game
    }
}

@Model
final class Score {
    var score: Int
    var hole: Hole? // Idk why this has to be optional. Remove and it complains about objects being in different contexts
    var player: Player
    var game: Game
    
    init(score: Int = 0, hole: Hole, player: Player, game: Game) {
        self.score = score
        self.hole = hole
        self.player = player
        self.game = game
    }
}
