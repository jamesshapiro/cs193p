//
//  Concentration.swift
//  Concentration
//
//  Created by James Shapiro on 3/7/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import Foundation
import GameKit

class Concentration {
    var cards = [Card]()
    var numFlips = 0
    var score = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    var previouslyFlippedCards = Set<Int>()
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            numFlips += 1
            // one card is already face up, and the selected card is not the face-up card
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    var penalty = 0
                    if previouslyFlippedCards.contains(index) {
                        penalty += 1
                    }
                    if previouslyFlippedCards.contains(matchIndex) {
                        penalty += 1
                    }
                    score -= penalty
                    
                }
                previouslyFlippedCards.insert(index)
                previouslyFlippedCards.insert(matchIndex)
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
    }
    // TODO: Shuffle the cards
}
