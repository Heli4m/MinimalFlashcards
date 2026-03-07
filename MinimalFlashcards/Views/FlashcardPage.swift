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
        GeometryReader { geometry in
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
                        
                        Button {
                            withAnimation {
                                flashCards = storedflashCards
                                wrongCount = 0
                                correctCount = 0
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Config.Colors.item.opacity(0.5), lineWidth: 2)
                                .padding(.top)
                                .frame(width: geometry.size.width - 100, height: geometry.size.height / 5)
                                .foregroundStyle(Config.Colors.background)
                                .shadow(color: Config.Colors.item, radius: 5)
                                .overlay {
                                    LexendMediumText(text: "Reset Deck?", size: 30)
                                        .padding(.top)
                                }
                        }
                    }
                } else {
                    ZStack {
                        ForEach(flashCards) { card in
                            SwipeWrapper(
                                wrongCount: $wrongCount,
                                correctCount: $correctCount,
                                onRemove: {
                                    withAnimation(.spring) {
                                        if let index = flashCards.firstIndex(where: { $0.id == card.id }) {
                                            flashCards.remove(at: index)
                                        }
                                    }
                                }) {
                                    Flashcard(
                                        clue: card.clue,
                                        answer: card.answer)
                                }
                        }
                    }
                }
            }
            .id(flashCards.count == storedflashCards.count)
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
