//
//  ContentView.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct ContentView: View {
    @State private var decks: [DeckModel] = []
    @State private var activeDeck: UUID? = nil
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
                self.activeDeck = deck.id
                
                withAnimation {
                    selectedTab = .flashCardPage
                }
            }
            .tag(TabEnum.deckPage)
            
            
            FlashcardPage(
                flashCards: $flashCards,
                storedflashCards: $storedflashCards
            ) { percentage in
                if let index = decks.firstIndex(where: { $0.id == activeDeck }) {
                    if percentage > decks[index].personalBest {
                        decks[index].personalBest = percentage
                    }
                }
            }
            .tag(TabEnum.flashCardPage)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .onAppear {
            loadDecks()
        }
        .onChange(of: decks) {
            saveDecks()
        }
    }
    
    func saveDecks() {
        if let encoded = try? JSONEncoder().encode(decks) {
            UserDefaults.standard.set(encoded, forKey: "decks")
        }
    }
    
    func loadDecks() {
        if let data = UserDefaults.standard.data(forKey: "decks") {
            if let decoded = try? JSONDecoder().decode([DeckModel].self, from: data) {
                decks = decoded
            }
        }
    }
}

#Preview {
    ContentView()
}
