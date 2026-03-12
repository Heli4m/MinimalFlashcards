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
        .onAppear {
            loadDecks()
        }
        .onChange(of: decks) { _ in
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
