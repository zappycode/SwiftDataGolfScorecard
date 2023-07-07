//
//  CreatePlayerView.swift
//  Golf
//
//  Created by Nick Walter on 6/14/23.
//

import SwiftUI
import MCEmojiPicker

struct CreatePlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newPlayer = Player(name: "")
    @State private var isPresented = false
    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            ProfileCircleView(emoji: $newPlayer.emoji)
                            Spacer()
                        }
                        
                        Button(action: {
                            focusedField = nil
                            isPresented.toggle()
                        }) {
                            Text("New Emoji")
                        }
                        .emojiPicker(isPresented: $isPresented, selectedEmoji: $newPlayer.emoji)
                    }
                }
                
                Section {
                    TextField("Name", text: $newPlayer.name)
                        .onSubmit {
                            if !newPlayer.name.isEmpty {
                                createPlayer()
                            }
                        }
                        .submitLabel(.done)
                        .focused($focusedField, equals: .name)
                    
                }
                
                
                Section {
                    Button(action: {
                        createPlayer()
                    }, label: {
                        Text("Add Player")
                    })
                    .disabled(newPlayer.name.isEmpty)
                }
            }
            .onAppear {
                focusedField = .name
            }
            .navigationTitle("New Golfer")
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
    
    func createPlayer() {
        newPlayer.addToGame = true
        modelContext.insert(newPlayer)
        dismiss()
    }
}

private enum FocusedField {
    case name
}

// This was causing an error as of beta 2

//#Preview {
//    CreatePlayerView(game: Game(players: []))
//}
