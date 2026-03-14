//
//  TextInput.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct TextInput: View {
    @State private var text: String = ""
    @State private var textDict: [String: String] = [:]
    @State private var error: Bool = false
    @State private var isNaming: Bool = false
    @State private var deckName: String = ""
    @State private var showingAlert: Bool = false
    
    @Binding var flashCards: [FlashcardModel]
    @Binding var storedflashCards: [FlashcardModel]
    @Binding var activeDeck: UUID?
    @Binding var decks: [DeckModel]
    @Binding var selectedTab: TabEnum
    
    let onGenerateCards: () -> Void
    
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            VStack {
                LexendMediumText(text: "Input text with formatting", size: 24)
                    .foregroundStyle(Config.Colors.primaryText)
                    .padding(.top)
                
                textInput
                
                HStack {
                    Button {
                        pasteText()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Config.Colors.item)
                            .frame(width: 70, height: 70)
                            .overlay {
                                Image(systemName: "clipboard")
                                    .font(.system(size: 30))
                                    .foregroundStyle(Config.Colors.primaryText)
                            }
                    }
                    .padding(.trailing, 2)
                    
                    Button {
                        gatherText()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Config.Colors.accent)
                            .frame(width: 175, height: 75)
                            .overlay {
                                LexendMediumText(text: "Submit", size: 30)
                                    .foregroundStyle(error ? Config.Colors.highPriority : Config.Colors.primaryText)
                            }
                    }
                    
                    Button {
                        showingAlert = true
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Config.Colors.highPriority)
                            .frame(width: 70, height: 70)
                            .overlay {
                                Image(systemName: "trash")
                                    .font(.system(size: 30))
                                    .foregroundStyle(Config.Colors.primaryText)
                            }
                    }
                    .padding(.leading, 2)
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $isNaming) {
            DeckEditSheet(deckName: $deckName) {
                let newDeck = DeckModel(name: deckName, flashcards: flashCards, personalBest: 0)
                
                decks.append(newDeck)
                activeDeck = newDeck.id
                
                isNaming = false
                text = ""
                deckName = ""
            }
        }
        
        .alert("Clear all texts?", isPresented: $showingAlert) {
            Button ("Cancel", role: .cancel) {
                
            }
            
            Button ("Delete", role: .destructive) {
                text = ""
            }
        }
    }
    
    
    func gatherText() {
        let lines = text.components(separatedBy: ",")
        
        var newCards: [FlashcardModel] = []
        
        for line in lines {
            let parts = line.split(separator: ":", maxSplits: 1)
            
            if parts.count == 2 {
                let clue = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let answer = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                let newCard = FlashcardModel(
                    clue: clue,
                    answer: answer
                )
                
                newCards.append(newCard)
            }
        }
        
        self.flashCards = newCards
        self.storedflashCards = newCards
        self.isNaming = true
        onGenerateCards()
    }
    
    func pasteText() {
        if let clipboardText = UIPasteboard.general.string {
            if self.text.isEmpty {
                self.text = clipboardText
            } else {
                self.text += ",\n" + clipboardText
            }
        }
    }
}

private extension TextInput {
    var textInput: some View {
        TextEditor(text: $text)
            .font(.body)
            .foregroundStyle(Config.Colors.primaryText)
            .frame(minHeight: 200)
            .frame(width: 330)
            .padding()
            .scrollContentBackground(.hidden)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(Config.Colors.item)
            }
    }
}

#Preview {
    TextInput(
        flashCards: .constant([]),
        storedflashCards: .constant([]),
        activeDeck: .constant(UUID()),
        decks: .constant([]),
        selectedTab: .constant(.createPage),
        onGenerateCards: {
            print("Cards generated!")
        }
    )
}
