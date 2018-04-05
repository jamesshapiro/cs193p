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
    var numberOfCardsMatched = 0
    var numFlips = 0
    var score = 0
    let wrongCardDeduction = 1
    var indexOfOneAndOnlyFaceUpCardEligibleForMatching: Int?
    var previouslyFlippedCards = Set<Int>()
    var now = Date()
    var timeBonus = 32
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            // if exactly one card is already face up
            if let matchIndex = indexOfOneAndOnlyFaceUpCardEligibleForMatching {
                // no-op if you select the card that is already face-up
                if matchIndex == index {
                    return
                }
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                    numberOfCardsMatched += 2
                    if numberOfCardsMatched == cards.count {
                        let timePenalty = -Int(now.timeIntervalSinceNow)
                        score += max(0, timeBonus - timePenalty)
                        cards[matchIndex].isFaceUp = false
                        cards[index].isFaceUp = false
                    }
                } else {
                    // deduct one point for every previously flipped card involved in the non-match
                    var penalty = 0
                    if previouslyFlippedCards.contains(index) {
                        penalty += wrongCardDeduction
                    }
                    if previouslyFlippedCards.contains(matchIndex) {
                        penalty += wrongCardDeduction
                    }
                    score -= penalty
                }
                previouslyFlippedCards.insert(index)
                previouslyFlippedCards.insert(matchIndex)
                if numberOfCardsMatched < cards.count {
                    cards[index].isFaceUp = true
                }
                indexOfOneAndOnlyFaceUpCardEligibleForMatching = nil
            } else { // either no cards or 2 cards are face up
                // no-op if you select a card that is already face-up.
                if cards[index].isFaceUp {
                    return
                }
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCardEligibleForMatching = index
            }
            numFlips += 1
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
    }
}
