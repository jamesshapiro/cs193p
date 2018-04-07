//
//  Concentration.swift
//  Concentration
//
//  Created by James Shapiro on 3/7/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import Foundation
import GameKit

struct Concentration {
    var cards = [Card]()
    private var numberOfCardsMatched = 0
    var numFlips = 0
    var score = 0
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUps = cards.indices.filter { cards[$0].isFaceUp }
            return faceUps.count == 1 ? faceUps[0] : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var previouslyFlippedCards = Set<Int>()
    var now = Date()
    var timeBonus = 32
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        // player may not select a card that has already been matched (hence removed from the game)
        guard !cards[index].isMatched else {
            return
        }
        // player may not select a card that is already face up
        guard !cards[index].isFaceUp else {
            return
        }

        // if exactly one card is already face up
        if let matchIndex = indexOfOneAndOnlyFaceUpCard {
            // check if cards match
            if cards[matchIndex] == cards[index] {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
                score += 2
                numberOfCardsMatched += 2
                if numberOfCardsMatched == cards.count {
                    let timePenalty = -1 * Int(now.timeIntervalSinceNow)
                    score += max(0, timeBonus - timePenalty)
                    cards[matchIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                }
            } else {
                // deduct one point for every previously flipped card involved in the non-match
                score -= [index, matchIndex].filter{ previouslyFlippedCards.contains($0) }.count
            }
            previouslyFlippedCards.insert(index)
            previouslyFlippedCards.insert(matchIndex)
            if numberOfCardsMatched < cards.count {
                cards[index].isFaceUp = true
            }
        } else { // either no cards or 2 cards are face up
            indexOfOneAndOnlyFaceUpCard = index
        }
        numFlips += 1
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards)): number of pairs of cards must be positive")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
    }
}
