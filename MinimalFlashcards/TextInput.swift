//
//  TextInput.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct TextInput: View {
    @State private var text: String = ""
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            VStack {
                LexendMediumText(text: "Input text with formatting", size: 24)
                    .foregroundStyle(Config.Colors.primaryText)
                textInput
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
            .frame(width: 350)
            .padding()
            .scrollContentBackground(.hidden)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Config.Colors.item)
            }
    }
}

#Preview {
    TextInput()
}
