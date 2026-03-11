//
//  DeckView.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 9/3/26.
//

import SwiftUI

struct DeckView: View {
    let decks: [DeckModel]
    let onStart: (DeckModel) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 15, alignment: .top),
        GridItem(.flexible(), spacing: 15, alignment: .top)
    ]
    
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid (columns: columns, spacing: 15) {
                    ForEach(decks) { deck in
                        Button {
                            onStart(deck)
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 225)
                                .foregroundStyle(Config.Colors.item)
                                .overlay {
                                    VStack {
                                        Spacer()
                                        
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
                                        
                                        Spacer()
                                    }
                                }
                            
                        }
                    }
                }
                .padding()
            }
        }
    }
}
