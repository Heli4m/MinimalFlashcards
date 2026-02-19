//
//  FlashcardModel.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct Flashcard: View {
    let id = UUID()
    let clue: String
    let answer: String
    @State private var rotation: Double = 0
    @State private var isFlipped: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 400)
                .foregroundStyle(Config.Colors.item)
                .onTapGesture { tap in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        rotation += 180
                        isFlipped.toggle()
                    }
                }
                .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            
            if isFlipped {
                LexendMediumText(text: answer, size: 20)
                    .foregroundStyle(Config.Colors.primaryText)
            } else if !isFlipped {
                LexendMediumText(text: clue, size: 20)
                    .foregroundStyle(Config.Colors.primaryText)
            }
        }
    }
}

#Preview {
    Flashcard(clue: "Single Bedroom", answer: "das Einzelzimmer")
}
