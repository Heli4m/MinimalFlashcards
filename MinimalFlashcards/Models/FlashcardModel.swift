//
//  FlashcardModel.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import Foundation

struct FlashcardModel: Identifiable, Codable, Equatable {
    var id = UUID()
    let clue: String
    let answer: String
}

struct DeckModel: Identifiable, Codable, Equatable {
    var id = UUID()
    var rawText: String
    let name: String
    var flashcards: [FlashcardModel]
    var personalBest: Int
    var isShuffled: Bool = true
}
