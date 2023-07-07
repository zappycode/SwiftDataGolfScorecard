//
//  ScoreView.swift
//  Golf
//
//  Created by Nick Walter on 6/29/23.
//

import SwiftUI

struct ScoreView: View {
    
    @State var score: Score
    @State private var showingAlert = false
    
    var body: some View {
        Button(action:{
            showingAlert.toggle()
        }) {
            Text("\(score.score)")
        }
        .alert("Score for \(score.player.name) on Hole \(score.hole!.number)", isPresented: $showingAlert) {
            TextField("Score", value: $score.score, formatter: NumberFormatter())
                .keyboardType(.numberPad)
            Button("OK", action: {})
        }
    }
}


