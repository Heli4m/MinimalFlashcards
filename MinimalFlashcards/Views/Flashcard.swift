//
//  FlashcardModel.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

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
                LexendMediumText(text: text, size: 20)
                    .foregroundStyle(Config.Colors.primaryText)
                    .padding()
            }
    }
}

#Preview {
    Flashcard(clue: "Single Bedroom", answer: "das Einzelzimmer")
}
