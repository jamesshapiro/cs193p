//
//  PlayingCardDeck.swift
//  SetGame
//
//  Created by James Shapiro on 4/26/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//
//  Combinations function copied from: https://github.com/almata/Combinatorics/blob/master/Combinatorics/Combinatorics.swift

import Foundation
import GameKit

struct SetCardGame {
    private var cards = [PlayingCard]()
    private var cardsFlippedSoFar = 0
    private var cardsMatched = [Int]()
    var now = Date()
    
    var isOutOfCards: Bool {
        return cardsFlippedSoFar == cards.count
    }
    
    private var indicesOfActiveCardSlots: [Int] {
        return Array(slotsToDeck.keys)
    }
    
    private var slotsToDeck = [Int: Int]()
    private(set) var score = 0
    private(set) var computerScore = 0
    
    mutating func updatePlayerVsComputerScore(with indices: [Int], forHuman: Bool) {
        if forHuman {
            score += 1
        } else {
            computerScore += 1
        }
        cardsMatched += indices.map { slotsToDeck[$0]! }
    }
    
    mutating func updateScore(with indices: [Int]? = nil, unnecessaryDrawThree: Bool = false) {
        if unnecessaryDrawThree {
            if cardsFlippedSoFar >= 12 {
                score -= 30
            }
            return
        }
        if let indices = indices {
            if indices.count < 3 {
                return
            }
            if cardsFormASet(with: indices) {
                let timeBonus = 3 * max(9 + Int(now.timeIntervalSinceNow), 0)
                now = Date()
                score += 3 + timeBonus
                cardsMatched += indices.map { slotsToDeck[$0]! }
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
        let numberOfTypesOfEachDimension = cardDimensions.map { $0.unique }
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
    
    func findASetOfCards() -> [Int]? {
        let everyCombinationOfCardsOnTheBoard = combinationsWithoutRepetitionFrom(indicesOfActiveCardSlots, taking: 3)
        var detectedSets = everyCombinationOfCardsOnTheBoard.filter { cardsFormASet(with: $0) }
        detectedSets = detectedSets.filter {
            !$0.contains(where: {cardsMatched.contains(slotsToDeck[$0]!)})
        }
        return detectedSets.count > 0 ? detectedSets[0] : nil
    }
    
    private func combinationsWithoutRepetitionFrom<T>(_ elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= taking else { return [] }
        guard elements.count > 0 && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var combinations = [[T]]()
        for (index, element) in elements.enumerated() {
            var reducedElements = elements
            reducedElements.removeFirst(index + 1)
            combinations += combinationsWithoutRepetitionFrom(reducedElements, taking: taking - 1).map {[element] + $0}
        }
        return combinations
    }
}

private extension Array where Element: Hashable {
    var unique: Int {
        return Set(self).count
    }
}
