//
//  TextInput.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct TextInput: View {
    @FocusState private var isInputActive: Bool
    
    @Binding var text: String
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
    @Binding var editingDeck: UUID?
    
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
                    .focused($isInputActive)
                
                HStack {
                    Button {
                        gatherText()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Config.Colors.accent)
                            .frame(width: 175, height: 75)
                            .overlay {
                                LexendMediumText(text: editingDeck == nil ? "Create" : "Update", size: 30)
                                    .foregroundStyle(error ? Config.Colors.highPriority : Config.Colors.primaryText)
                            }
                    }
                }
                .padding(.top)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                     
                HStack {
                    Button ("Done") {
                        isInputActive = false
                    }
                    .font(Font.custom("Lexend-Medium", size: 16))
                    .foregroundStyle(Config.Colors.accent)
                }
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .bottom))
            }
        }
        .sheet(isPresented: $isNaming) {
            DeckEditSheet(deckName: $deckName) {
                let newDeck = DeckModel(rawText: text, name: deckName, flashcards: flashCards, personalBest: 0)
                
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
                    .replacingOccurrences(of: "\"", with: "")
                    .replacingOccurrences(of: "'", with: "")
                    .replacingOccurrences(of: "“", with: "")
                    .replacingOccurrences(of: "”", with: "")
                let answer = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\"", with: "")
                    .replacingOccurrences(of: "'", with: "")
                    .replacingOccurrences(of: "“", with: "")
                    .replacingOccurrences(of: "”", with: "")
                
                let newCard = FlashcardModel(
                    clue: clue,
                    answer: answer
                )
                
                newCards.append(newCard)
            }
        }
        
        self.flashCards = newCards
        self.storedflashCards = newCards
        if editingDeck == nil {
            self.isNaming = true
        } else {
            if let index = decks.firstIndex(where: { $0.id == editingDeck }) {
                decks[index].rawText = text
                decks[index].flashcards = newCards
            }
            
            text = ""
            editingDeck = nil
        }
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
        ZStack {
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
            
            HStack {
                Spacer()
                VStack {
                    Button {
                        showingAlert = true
                    } label: {
                        Circle()
                            .foregroundStyle(Config.Colors.highPriority)
                            .frame(width: 45, height: 45)
                            .overlay {
                                Image(systemName: "trash")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Config.Colors.primaryText)
                            }
                            .overlay {
                                Circle()
                                    .stroke(Config.Colors.background, lineWidth: 2)
                            }
                    }
                    
                    Button {
                        pasteText()
                    } label: {
                        Circle()
                            .foregroundStyle(Config.Colors.item)
                            .frame(width: 45, height: 45)
                            .overlay {
                                Image(systemName: "clipboard")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Config.Colors.primaryText)
                            }
                            .overlay {
                                Circle()
                                    .stroke(Config.Colors.background, lineWidth: 2)
                            }
                    }
                    
                    Button {
                        editingDeck = nil
                    } label: {
                        Circle()
                            .foregroundStyle(editingDeck == nil ? Config.Colors.inactiveAccent : Config.Colors.accent)
                            .frame(width: 45, height: 45)
                            .overlay {
                                Image(systemName: "plus.square.fill.on.square.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Config.Colors.primaryText)
                            }
                            .overlay {
                                Circle()
                                    .stroke(Config.Colors.background, lineWidth: 2)
                            }
                    }
                    .disabled(editingDeck == nil)
                }
                .padding(.trailing, 5)
            }
        }
    }
}

#Preview {
    TextInput(
        text: .constant("Pommes : Fries"),
        flashCards: .constant([]),
        storedflashCards: .constant([]),
        activeDeck: .constant(UUID()),
        decks: .constant([]),
        selectedTab: .constant(.createPage),
        editingDeck: .constant(UUID()),
        onGenerateCards: {
            print("Cards generated!")
        }
    )
}
