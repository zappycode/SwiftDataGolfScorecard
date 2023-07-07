//
//  GameView.swift
//  Golf
//
//  Created by Nick Walter on 6/27/23.
//

import SwiftUI
import SwiftData

struct GameView: View {
    
    @Environment(\.modelContext) private var modelContext

    @State var game: Game
    @State var currentHoleIndex = 0
    @State private var showingAlert = false
    @State var selectedScore: Score?
    @State var tempScoreInt = 0
    @State var alertTitle = ""
    @State var showingScoresView = false
    
    private let myFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(game.players.sorted(by: { player1, player2 in player1.name < player2.name })) { player in
                    HStack {
                        HStack {
                            Text(player.emoji)
                                .font(.title)
                            VStack(alignment: .leading) {
                                Text(player.name)
                                    .font(.title2)
                                Text(player.strokesBehindString(game: game))
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action:{
                            selectedScore = player.scoreFor(hole: holes()[currentHoleIndex])
                            tempScoreInt = selectedScore?.score ?? 0
                            alertTitle = "Score for \(player.name) on Hole \(holes()[currentHoleIndex].number)"
                            showingAlert.toggle()
                        }) {
                            if player.scoreFor(hole: holes()[currentHoleIndex])!.score == 0 {
                                Text("Add")
                                    .foregroundStyle(.red)
                            } else {
                                Text("\(player.scoreFor(hole: holes()[currentHoleIndex])!.score)")
                                    .font(.title)
                            }
                        }
                        .alert(alertTitle, isPresented: $showingAlert) {
                            TextField("Score", value: $tempScoreInt, formatter: myFormatter)
                                .keyboardType(.numberPad)
                            Button("OK", action: {
                                selectedScore?.score = tempScoreInt
                            })
                        }
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
            Spacer()
            HStack {
                Button("Previous") {
                    currentHoleIndex -= 1
                }
                .disabled(currentHoleIndex <= 0)
                Spacer()
                Button("Next") {
                    currentHoleIndex += 1
                }
                .disabled(currentHoleIndex >= 17)
            }
            .padding()
        }
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < 0 {
                    //print("Left")
                    if currentHoleIndex <= 16 {
                        currentHoleIndex += 1
                    }
                }
                
                if value.translation.width > 0 {
                    //print("Right")
                    if currentHoleIndex >= 1 {
                        currentHoleIndex -= 1
                    }
                }
            }))
        .toolbar {
            Button("Scores") {
                showingScoresView.toggle()
            }
        }
        .sheet(isPresented: $showingScoresView) {
            ScoresView(game: game)
        }
        .navigationTitle("Hole \(holes()[currentHoleIndex].number)")
    }
    
    func holes() -> [Hole] {
        return game.holes.sorted(by: { hole1, hole2 in hole1.number < hole2.number })
    }
}

//@MainActor
//#Preview {
//
//        let container = PreviewSampleData.container
//
//        return NavigationStack {
//            GameView(game: Game(players: [Player(name: "Joe")]))
//        }
//        .modelContainer(container)
//}

//@MainActor
//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let container = PreviewSampleData.container
//
//        return NavigationStack {
//            GameView(game: Game(players: [Player(name: "Joe")]))
//        }.modelContainer(container)
//
//    }
//}
