//
//  EditPlayerView.swift
//  Golf
//
//  Created by Nick Walter on 6/22/23.
//

import SwiftUI
import SwiftData

struct EditPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isPresented = false
    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) var dismiss
    @State var player: Player
    @State var deletePlayer = false
    @State var showDeletePopup = false
    
    var body: some View {
        Form {
            Section {
                VStack {
                    HStack {
                        Spacer()
                        ProfileCircleView(emoji: $player.emoji)
                        Spacer()
                    }
                    
                    Button(action: {
                        focusedField = nil
                        isPresented.toggle()
                    }) {
                        Text("New Emoji")
                    }
                    .emojiPicker(isPresented: $isPresented, selectedEmoji: $player.emoji)
                }
            }
            
            Section {
                TextField("Name", text: $player.name)
                    .focused($focusedField, equals: .name)
            }
            
            Section {
                Button(action: {
                    player.addToGame = false
                    dismiss()
                }, label: {
                    Text("Remove From Game")
                })
            }
        }
        .toolbar {
            Button(action: {
                showDeletePopup.toggle()
            }) {
                Image(systemName: "trash")
            }
            .tint(.red)
            .alert("Are you sure you want to delete \(player.name)?", isPresented: $showDeletePopup) {
                Button(role: .destructive, action: {
                    deletePlayer = true
                    dismiss()
                }) {
                    Text("Delete")
                }
            }
        }
        .onAppear {
            focusedField = .name
        }
        .onDisappear { // Need to do this because otherwise the view freaks out that it's trying to show somehting that doesn't exist
            
            // Known issue? "After deleting an item, SwiftUI may attempt to reference the deleted content during the animation causing a crash. (109838173)"
            // Workaround: Explicitly save after a delete. (THIS DIDN'T WORK FOR ME)

            if deletePlayer {
                modelContext.delete(player)
                try? modelContext.save()
            }
        }
    }
}

private enum FocusedField {
    case name
}

//#Preview {
//    EditPlayerView(player: Player(name: "Mark"))
//}
