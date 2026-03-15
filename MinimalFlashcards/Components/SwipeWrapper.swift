//
//  SwipeWrapper.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct SwipeWrapper<Content: View>: View {
    @Binding var wrongCount: Int
    @Binding var correctCount: Int
    var onRemove: (Bool) -> Void
    let content: () -> Content
    @State private var hasPlayedHaptics: Bool = false
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.green
                .opacity(offset.width > 100 && offset.width < 1000 ? offset.width * 0.001 : 0)
                .allowsHitTesting(false)
            
            Color.red
                .opacity(offset.width < -100 && offset.width > -1000 ? abs(offset.width) * 0.001 : 0)
                .allowsHitTesting(false)
            
            content()
                .offset(x: offset.width, y: offset.height * 0.4)
                .rotationEffect(.degrees(Double(offset.width / 30)))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                            
                            if abs(value.translation.width) > 100 && !hasPlayedHaptics {
                                Haptics.trigger(.light)
                                hasPlayedHaptics = true
                            } else if abs(value.translation.width) < 100 {
                                hasPlayedHaptics = false
                            }
                        }
                        .onEnded { value in
                            if abs(value.translation.width) > 100 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    offset.width = value.translation.width > 0 ? 1000 : -1000
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if value.translation.width > 100 {
                                        correctCount += 1
                                        onRemove(true)
                                    } else if value.translation.width < -100 {
                                        wrongCount += 1
                                        onRemove(false)
                                    }
                                    offset = .zero
                                }
                                
                            } else {
                                withAnimation(.spring) { offset = .zero}
                            }
                        }
                )
        }
        .ignoresSafeArea()
    }
}
