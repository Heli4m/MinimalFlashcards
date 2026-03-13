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
    
    @Binding var flashCards: [FlashcardModel]
    @Binding var storedflashCards: [FlashcardModel]
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
                            .frame(width: 75, height: 75)
                            .overlay {
                                Image(systemName: "clipboard")
                                    .font(.system(size: 35))
                                    .foregroundStyle(Config.Colors.primaryText)
                            }
                    }
                    
                    Button {
                        gatherText()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Config.Colors.accent)
                            .frame(width: 200, height: 75)
                            .overlay {
                                LexendMediumText(text: "Submit", size: 30)
                                    .foregroundStyle(error ? Config.Colors.highPriority : Config.Colors.primaryText)
                            }
                    }
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $isNaming) {
            DeckEditSheet(deckName: $deckName) {
                let newDeck = DeckModel(name: deckName, flashcards: flashCards, personalBest: 0)
                
                decks.append(newDeck)
                
                isNaming = false
                text = ""
                deckName = ""
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
        decks: .constant([]),
        selectedTab: .constant(.createPage),
        onGenerateCards: {
            print("Cards generated!")
        }
    )
}
