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
    private var cards = [PlayingCard]()
    private var cardsFlippedSoFar = 0
    var isOutOfCards: Bool {
        return cardsFlippedSoFar == cards.count
    }
    private var slotsToDeck = [Int: Int]()
    private(set) var score = 0
    
    mutating func updateScore(with indices: [Int]? = nil) {
        if let indices = indices {
            if indices.count < 3 {
                return
            }
            if cardsFormASet(with: indices) {
                score += 3
            } else {
                score -= 5
            }
        } else {
            score -= 1
        }
    }
    
    func cardsFormASet(with indices: [Int]) -> Bool {
        guard indices.count == 3 else {
            return false
        }
        let matchCandidates = indices.map { cards[slotsToDeck[$0]!] }
        let cardDimensions = [matchCandidates.map { $0.fill.rawValue },
                              matchCandidates.map { $0.color.rawValue },
                              matchCandidates.map { $0.pipCount.rawValue },
                              matchCandidates.map{ $0.shape.rawValue }]
        let numberOfTypesOfEachDimension = cardDimensions.map { Set($0).count }
        return numberOfTypesOfEachDimension.filter { $0 == 2 }.count == 0
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
                for pipCount in PlayingCard.PipCount.all {
                    for color in PlayingCard.CardColor.all {
                        cards.append(PlayingCard(shape: shape, fill: fill, pipCount: pipCount, color: color))
                    }
                }
            }
        }
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [PlayingCard]
    }
}
