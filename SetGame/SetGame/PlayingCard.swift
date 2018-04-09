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
    var pipCount: Int
    var color: CardColor
    
    enum Shape {
        case shape1
        case shape2
        case shape3
        
        static var all = [Shape.shape1, .shape2, .shape3]
    }

    enum Fill {
        case texture1
        case texture2
        case texture3
        
        static var all = [Fill.texture1, .texture2, .texture3]
    }
    
    static var pipCounts = [1, 2, 3]
    
    enum CardColor: Int {
        case color1
        case color2
        case color3
        
        static var all = [CardColor.color1, .color2, .color3]
    }
}
