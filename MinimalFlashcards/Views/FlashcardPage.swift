//
//  FlashCardPage.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct FlashcardPage: View {
    @Binding var flashCards: [FlashcardModel]
    @Binding var storedflashCards: [FlashcardModel]
    @State private var wrongCount: Int = 0
    @State private var correctCount: Int = 0
    
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            
            if flashCards.isEmpty {
                VStack {
                    HStack {
                        LexendMediumText(text: String(correctCount), size: 40)
                            .foregroundStyle(Config.Colors.primaryText)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Config.Colors.successGreen)
                            .padding(.trailing)
                        
                        LexendMediumText(text: String(wrongCount), size: 40)
                            .foregroundStyle(Config.Colors.primaryText)
                        
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Config.Colors.errorRed)
                    }
                    .padding(.bottom)
                    
                    LexendMediumText(text: "No cards left!", size: 30)
                        .foregroundColor(Config.Colors.primaryText)
                }
            } else {
                ZStack {
                    ForEach(flashCards.indices, id: \.self) { index in
                        SwipeWrapper(
                            wrongCount: $wrongCount,
                            correctCount: $correctCount,
                            onRemove: {
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
    FlashcardPage(
        flashCards: .constant([]),
        storedflashCards: .constant([
            FlashcardModel(clue: "Hello", answer: "Bonjour"),
            FlashcardModel(clue: "Apple", answer: "Pomme"),
            FlashcardModel(clue: "House", answer: "Maison")
        ]),
    )
}
