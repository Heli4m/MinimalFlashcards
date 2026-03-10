//
//  DeckEditSheet.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 10/3/26.
//

import SwiftUI

struct DeckEditSheet: View {
    @Binding var deckName: String
    @State private var textLimit: Int = 30
    
    let onCreate: () -> Void
    
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            
            VStack (alignment: .leading) {
                HStack {
                    LexendMediumText(text: "Deck Name", size: 20)
                        .foregroundStyle(Config.Colors.accent)
                    
                    Spacer()
                    
                    LexendMediumText(text: "\(deckName.count)/\(textLimit)", size: 20)
                        .foregroundStyle(Config.Colors.accent.opacity(0.5))
                }
                    
                TextField(
                    text: $deckName,
                    prompt: Text("Deck Name")
                        .foregroundStyle(Config.Colors.accent.opacity(0.2))
                ) {
                    LexendMediumText(text: "Deck Name", size: 20)
                }
                .frame(height: 50)
                .font(Font.custom("Lexend-Regular", size: 20))
                .padding(.horizontal)
                .background(Color(Config.Colors.item))
                .foregroundStyle(Config.Colors.accent)
                .cornerRadius(30)
                .onChange(of: deckName) {
                    if deckName.count > textLimit {
                        deckName = String(deckName.prefix(textLimit))
                        Haptics.warning()
                    }
                }
                
                Button {
                    onCreate()
                } label: {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 50)
                        .foregroundStyle(Config.Colors.accent)
                        .overlay {
                            LexendMediumText(text: "Submit", size: 20)
                                .foregroundStyle(Config.Colors.primaryText)
                        }
                    
                }
                .padding(.top)
            }
            .padding()
        }
    }
}
