//
//  PlayingCardDeck.swift
//  SetGame
//
//  Created by James Shapiro on 4/8/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import Foundation
import GameKit

struct PlayingCardDeck {
    private(set) var cards = [PlayingCard]()
    private(set) var cardsFlippedSoFar = 0
    private var indicesOfCardsMatchedSoFar = [Int]()
    private var slotsToDeck = [Int: Int]()
    private(set) var score = 0
    var cardsMatchedSoFar: Int {
        return indicesOfCardsMatchedSoFar.count
    }
    
    mutating func cardsFormASet(indices: [Int]) -> Bool {
        let matchCandidates = indices.map { cards[slotsToDeck[$0]!] }

        let numFills = Set(matchCandidates.map { $0.fill }).count
        let numColors = Set(matchCandidates.map { $0.color }).count
        let numPipCounts = Set(matchCandidates.map { $0.pipCount }).count
        let numShapes = Set(matchCandidates.map{ $0.shape }).count

        let dimensions = [numFills, numColors, numPipCounts, numShapes]
        let isMatch = dimensions.filter { $0 == 2 }.count == 0
        if isMatch && !indicesOfCardsMatchedSoFar.contains(slotsToDeck[indices[0]]!) {
            score += 10
            indicesOfCardsMatchedSoFar += indices.map { slotsToDeck[$0]! }
        }
        return isMatch
    }
    
    mutating func getNextCard(forIndex: Int) -> PlayingCard {
        let card = cards[cardsFlippedSoFar]
        slotsToDeck[forIndex] = cardsFlippedSoFar
        cardsFlippedSoFar += 1
        return card
    }
    
    init() {
        for shape in PlayingCard.Shape.all {
            for fill in PlayingCard.Fill.all {
                for pipCount in PlayingCard.pipCounts {
                    for color in PlayingCard.CardColor.all {
                        cards.append(PlayingCard(shape: shape, fill: fill, pipCount: pipCount, color: color))
                    }
                }
            }
        }
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [PlayingCard]
    }
}
