//
//  MathView.swift
//  MinimalFlashcards
//
//  Created by Liam Ngo on 15/3/26.
//

import Foundation
import SwiftUI
import UIKit
import WebKit

struct MathView: UIViewRepresentable {
    let latex: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
            <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
            
            <style>
                body {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                    padding: 10px; /* Prevents math from touching the edges */
                    background-color: transparent;
                    color: white; 
                    overflow: hidden; /* Prevents accidental scrolling */
                }
                .mjx-chtml {
                    outline: none !important;
                }
                /* This is the magic part: forces math to stay within bounds */
                mjx-container {
                    max-width: 100% !important;
                    overflow-x: auto !important;
                    overflow-y: hidden !important;
                }
            </style>
        </head>
        <body>
            \\[ \(latex) \\]
        </body>
        </html>
        """
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}
