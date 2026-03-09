//
//  DeckView.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 9/3/26.
//

import SwiftUI

struct DeckView: View {
    let deck: DeckModel
    
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            
            HStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 160, height: 225)
                    .foregroundStyle(Config.Colors.item)
                    .overlay {
                        VStack {
                            LexendMediumText(text: deck.name, size: 24)
                                .foregroundStyle(Config.Colors.accent)
                                .multilineTextAlignment(.center)
                            
                            LexendMediumText(text: "\(String(deck.flashcards.count)) cards", size: 16)
                                .foregroundStyle(Config.Colors.primaryText)
                                .padding(.top, 0.25)
                                .padding(.bottom, 1)
                            
                            LexendMediumText(text: "\(deck.personalBest)%", size: 16)
                                .foregroundStyle(Config.Colors.primaryText)
                                .padding(.vertical, 1)
                        }
                    }
                
                Spacer()
            }
        }
    }
}

#Preview {
    DeckView(
        deck: .init(
            name: "German Vocab",
            flashcards: [
                FlashcardModel(clue: "Hello", answer: "Bonjour"),
                FlashcardModel(clue: "Apple", answer: "Pomme"),
                FlashcardModel(clue: "House", answer: "Maison")
            ],
            personalBest: 80)
    )
}
