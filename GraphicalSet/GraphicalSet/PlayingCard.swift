//
//  PlayingCard.swift
//  SetGame
//
//  Created by James Shapiro on 4/8/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import Foundation

struct PlayingCard {
    var shape: Shape
    var fill: Fill
    var pipCount: PipCount
    var color: CardColor
    
    enum Shape: Int {
        case shape1
        case shape2
        case shape3
        
        static var all = [Shape.shape1, .shape2, .shape3]
    }
    
    enum Fill: Int {
        case texture1
        case texture2
        case texture3
        
        static var all = [Fill.texture1, .texture2, .texture3]
    }
    
    enum PipCount: Int {
        case pipCountOne = 1
        case pipCountTwo
        case pipCountThree
        
        static var all = [PipCount.pipCountOne, .pipCountTwo, .pipCountThree]
    }
    
    enum CardColor: Int {
        case color1
        case color2
        case color3
        
        static var all = [CardColor.color1, .color2, .color3]
    }
}
