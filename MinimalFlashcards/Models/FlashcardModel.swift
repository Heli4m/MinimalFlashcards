//
//  FlashcardModel.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import Foundation

struct FlashcardModel: Identifiable, Codable{
    let id: UUID = UUID()
    let clue: String
    let answer: String
}
