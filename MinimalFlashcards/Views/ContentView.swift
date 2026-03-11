//
//  ContentView.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct ContentView: View {
    @State private var decks: [DeckModel] = []
    @State private var flashCards: [FlashcardModel] = []
    @State private var storedflashCards: [FlashcardModel] = []
    @State private var selectedTab: TabEnum = .createPage
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TextInput(flashCards: $flashCards, storedflashCards: $storedflashCards, decks: $decks, selectedTab: $selectedTab) {
                withAnimation {
                    selectedTab = .flashCardPage
                }
            }
            .tag(TabEnum.createPage)
            
            DeckView(decks: decks) { deck in
                self.flashCards = deck.flashcards
                self.storedflashCards = deck.flashcards
                
                withAnimation {
                    selectedTab = .flashCardPage
                }
            }
            .tag(TabEnum.deckPage)
            
            
            FlashcardPage(
                flashCards: $flashCards,
                storedflashCards: $storedflashCards
            )
            .tag(TabEnum.flashCardPage)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        
    }
    
}

#Preview {
    ContentView()
}
