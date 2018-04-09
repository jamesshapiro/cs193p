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
    private(set) var cardSlotsFlipped = 12
    private var slotsToDeck = [Int: Int]()
    
    
    func checkIfSetAndReplace(indices: [Int]) -> Bool {
        let matchCandidates = indices.map { cards[slotsToDeck[$0]!] }
        
        let numFills = Set(matchCandidates.map { $0.fill }).count
        let numColors = Set(matchCandidates.map { $0.color }).count
        let numPipCounts = Set(matchCandidates.map { $0.pipCount }).count
        let numShapes = Set(matchCandidates.map{ $0.shape }).count
        
        let dimensions = [numFills, numColors, numPipCounts, numShapes]
        return dimensions.filter { $0 == 2 }.count == 0
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
        for i in 0..<cardSlotsFlipped {
            slotsToDeck[i] = i
        }
    }
    
}
