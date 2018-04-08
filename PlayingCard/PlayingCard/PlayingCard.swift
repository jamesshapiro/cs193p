//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by James Shapiro on 4/7/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    var description: String { return "\(rank)\(suit)"}
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        case spades = "♠️"
        case hearts = "♥️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        var description: String {
            return self.rawValue
        }
        
        static var all = [Suit.spades, .hearts, .clubs, .diamonds]
    }
    
//    // the way you would actually do it
//    enum Rank {
//        case ace
//        case two
//        case three
//        case four
//        case five
//        case six
//        case seven
//        case eight
//        case nine
//        case ten
//        case jack
//        case queen
//        case king
//    }
    // the way it is written in lecture do demonstrate associated types for enums:
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }

        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(.numeric(pips))
            }
            allRanks += [.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
        
        
    }
}
