//
//  ContentView.swift
//  FlashcartStart
//
//  Created by Pegah Tafvizi on 9/4/23.

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var cards: [FlashCard] = [
        FlashCard(word: "Table", translation: "Tisch", imageName: "1"),
        FlashCard(word: "Door", translation: "Tür", imageName: "2"),
        FlashCard(word: "Chair", translation: "Stuhl", imageName: "3"),
        FlashCard(word: "Book", translation: "Buch", imageName: "4"),
        FlashCard(word: "Window", translation: "Fenster", imageName: "5")
    ]

    @State private var offset: CGSize = .zero
    @State private var background: Color = Color.white
    let threshold = UIScreen.main.bounds.width / 4
    let resistanceFactor: CGFloat = 0.3

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // To ensure the white screen behind cards
            
            if !cards.isEmpty {
                FlashCardView(flashCard: self.$cards.last!, backgroundColor: self.background)
                    .offset(self.offset)
                    .opacity(Double(1 - (abs(self.offset.width) / threshold)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let translation = gesture.translation
                                self.offset = CGSize(width: translation.width * resistanceFactor, height: 0)
                                if gesture.translation.width > 0 {
                                    self.background = Color.green.opacity(Double(translation.width / threshold))
                                } else {
                                    self.background = Color.red.opacity(Double(-translation.width / threshold))
                                }
                            }
                            .onEnded { gesture in
                                if abs(gesture.translation.width) > threshold {
                                    // Either remove or move the card based on the direction
                                    if gesture.translation.width > 0 {
                                        self.cards.removeLast()
                                    } else {
                                        let card = self.cards.removeLast()
                                        self.cards.insert(card, at: 0)
                                    }
                                }
                                self.background = Color.white
                                self.offset = .zero
                            }
                    )
            }
        }
    }
}
