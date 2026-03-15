//
//  FlashCardPage.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct FlashcardPage: View {
    @Binding var wrongflashCards: [FlashcardModel]
    @Binding var flashCards: [FlashcardModel]
    @Binding var storedflashCards: [FlashcardModel]
    @State private var wrongCount: Int = 0
    @State private var correctCount: Int = 0
    
    let onReturnPercentage: (Int) -> Void
    
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
                    .onAppear {
                        if !storedflashCards.isEmpty {
                            let percentage = (Double(correctCount) / Double(storedflashCards.count)) * 100
                            onReturnPercentage(Int(percentage))
                        }
                    }
                } else {
                    ZStack {
                        ForEach(flashCards) { card in
                            SwipeWrapper(
                                wrongCount: $wrongCount,
                                correctCount: $correctCount,
                                onRemove: { correct in
                                    withAnimation(.spring) {
                                        if let index = flashCards.firstIndex(where: { $0.id == card.id }) {
                                            flashCards.remove(at: index)
                                        }
                                    }
                                    
                                    if !correct {
                                        
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
        wrongflashCards: .constant([]),
        flashCards: .constant([]),
        storedflashCards: .constant([
            FlashcardModel(clue: "Hello", answer: "Bonjour"),
            FlashcardModel(clue: "Apple", answer: "Pomme"),
            FlashcardModel(clue: "House", answer: "Maison")
        ]),
        onReturnPercentage: { percentage in
            print("\(percentage)")
        }
    )
}

struct Flashcard: View {
    let clue: String
    let answer: String
    @State private var rotation: Double = 0
    @State private var isFlipped: Bool = false
    
    var body: some View {
        ZStack {
            CardFace(text: clue)
                .opacity(isFlipped ? 0 : 1)
            
            CardFace(text: answer)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 300, height: 400)
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isFlipped.toggle()
            }
        }
    }
}

struct CardFace: View {
    let text: String
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 300, height: 400)
            .foregroundStyle(Config.Colors.item)
            .overlay {
                if text.contains("$") {
                    let cleanedText = text.replacingOccurrences(of: "$", with: "")
                    
                    MathView(latex: cleanedText)
                        .frame(width: 260, height: 360)
                        .allowsHitTesting(false)
                } else {
                    LexendMediumText(text: text, size: 20)
                        .foregroundStyle(Config.Colors.primaryText)
                        .padding()
                }
            }
    }
}
