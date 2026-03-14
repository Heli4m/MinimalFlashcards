//
//  SharedComponents.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import Foundation
import SwiftUI

struct LexendRegularText: View {
    var text: String
    var size: CGFloat
    
    var body: some View {
        Text(text)
            .font(Font.custom("Lexend-Regular", size: size))
    }
}

struct LexendMediumText: View {
    var text: String
    var size: CGFloat
    
    var body: some View {
        Text(text)
            .font(Font.custom("Lexend-Medium", size: size))
    }
}

struct Cross: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 8, height: 35)
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 35, height: 8)
        }
        .foregroundStyle(Color.white)
    }
}
