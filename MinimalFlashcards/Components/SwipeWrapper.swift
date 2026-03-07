//
//  SwipeWrapper.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 19/2/26.
//

import SwiftUI

struct SwipeWrapper<Content: View>: View {
    var onRemove: () -> Void
    let content: () -> Content
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            content()
                .offset(x: offset.width, y: offset.height * 0.4)
                .rotationEffect(.degrees(Double(offset.width / 30)))
                .gesture(
                    DragGesture()
                        .onChanged { offset = $0.translation }
                        .onEnded { value in
                            if abs(value.translation.width) > 100 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    offset.width = value.translation.width > 0 ? 1000 : -1000
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                                onRemove()
                                                            }
                            } else {
                                withAnimation(.spring) { offset = .zero}
                            }
                        }
                )
            
            Color.green
                .opacity(offset.width > 100 ? 0.3 : 0)
            
            Color.red
                .opacity(offset.width < -100 ? 0.3 : 0)
        }
        .ignoresSafeArea()
    }
}
