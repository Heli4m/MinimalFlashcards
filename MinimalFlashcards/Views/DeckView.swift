//
//  DeckView.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 9/3/26.
//

import SwiftUI

struct DeckView: View {
    @Binding var decks: [DeckModel]
    @Binding var selectedTab: TabEnum
    let onStart: (DeckModel) -> Void
    let onEdit: (DeckModel) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 15, alignment: .top),
        GridItem(.flexible(), spacing: 15, alignment: .top)
    ]
    
    var filteredDecks: [DeckModel] {
        if searchText.isEmpty {
            return decks
        } else {
            return decks.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Config.Colors.background
                    .ignoresSafeArea()
                
                if decks.isEmpty {
                    VStack {
                        LexendMediumText(text: "Create your first deck!", size: 24)
                            .foregroundStyle(Config.Colors.secondaryText)
                        
                        Button {
                            selectedTab = .createPage
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color(Config.Colors.item.opacity(0.5)), lineWidth: 4)
                                    .frame(width: 82, height: 82)
                                
                                Circle()
                                    .fill(Config.Colors.accent)
                                    .frame(width: 75, height: 75)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
                                
                                Cross()
                            }
                        }
                        .padding(.top)
                    }
                } else {
                    ScrollView {
                        LazyVGrid (columns: columns, spacing: 15) {
                            ForEach(filteredDecks) { deck in
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
                                        .overlay {
                                            HStack {
                                                Spacer()
                                                
                                                VStack {
                                                    Image(systemName: deck.isShuffled ? "shuffle" : "line.3.horizontal" )
                                                        .foregroundStyle(Config.Colors.accent)
                                                    
                                                    
                                                    Spacer()
                                                }
                                            }
                                            .padding()
                                        }
                                    
                                }
                                .contextMenu {
                                    Button {
                                        onEdit(deck)
                                    } label: {
                                        Label (
                                            "Edit Deck",
                                            systemImage: "square.and.pencil"
                                        )
                                    }
                                    
                                    Button {
                                        if let index = decks.firstIndex(where: { $0.id == deck.id }) {
                                            decks[index].isShuffled.toggle()
                                            Haptics.trigger(.light)
                                        }
                                    } label: {
                                        Label (
                                            deck.isShuffled ? "Shuffle: ON" : "Shuffle: OFF",
                                            systemImage: deck.isShuffled ? "shuffle" : "line.3.horizontal"
                                        )
                                    }
                                    
                                    Button(role: .destructive) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            deleteDeck(selectedDeck: deck)
                                        }
                                        Haptics.trigger(.rigid)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .scrollDismissesKeyboard(.interactively)
                }
            }
            .navigationTitle("My Decks")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search your decks..."
            )
            .autocorrectionDisabled(true)
        }
    }
    
    func deleteDeck(selectedDeck: DeckModel) {
        if let index = decks.firstIndex(where: { $0.id == selectedDeck.id }) {
            decks.remove(at: index)
        }
    }
}

