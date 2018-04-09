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
