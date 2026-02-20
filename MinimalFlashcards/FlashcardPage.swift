//
//  FlashCardPage.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct FlashcardPage: View {
    @Binding var flashCards: [FlashcardModel]
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            
            if flashCards.isEmpty {
                LexendMediumText(text: "No cards left!", size: 30)
                    .foregroundColor(Config.Colors.primaryText)
            } else {
                ZStack {
                    ForEach(flashCards.indices, id: \.self) { index in
                        SwipeWrapper(onRemove: {
                            flashCards.remove(at: index)
                        }) {
                            Flashcard(
                                clue: flashCards[index].clue,
                                answer: flashCards[index].answer)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FlashcardPage(flashCards: .constant([
        FlashcardModel(clue: "Hello", answer: "Bonjour"),
        FlashcardModel(clue: "Apple", answer: "Pomme"),
        FlashcardModel(clue: "House", answer: "Maison")
    ]))
}
