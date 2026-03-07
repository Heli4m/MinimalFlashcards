//
//  ContentView.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct ContentView: View {
    @State private var flashCards: [FlashcardModel] = []
    @State private var storedflashCards: [FlashcardModel] = []
    @State private var selectedTab: TabEnum = .createPage
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TextInput(flashCards: $flashCards) {
                withAnimation {
                    selectedTab = .flashCardPage
                }
            }
            .tag(TabEnum.createPage)
            
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
