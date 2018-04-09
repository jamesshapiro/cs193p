//
//  ViewController.swift
//  SetGame
//
//  Created by James Shapiro on 4/8/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var deck: PlayingCardDeck! = nil

    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        print("hello moto!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deck = PlayingCardDeck()
        updateViewFromModel()
    }
    
    func getCardFace(card: PlayingCard) -> NSAttributedString {
        var attributes = [NSAttributedStringKey: Any]()
        var buttonText = ""
        var color: UIColor! = nil
        switch card.shape {
        case .shape1:
            buttonText = "▲"
        case .shape2:
            buttonText = "●"
        case .shape3:
            buttonText = "■"
        }
        buttonText = String(repeating: buttonText, count: card.pipCount.rawValue)
        
        switch card.color {
        case .color1:
            color = UIColor.red
        case .color2:
            color = UIColor.green
        case .color3:
            color = UIColor.blue
        }
        
        attributes[.strokeWidth] = 5
        switch card.fill {
        case .texture1:
            attributes[.foregroundColor] = color.withAlphaComponent(1.0)
            attributes[.strokeWidth] = 5
        case .texture2:
            attributes[.foregroundColor] = color.withAlphaComponent(0.15)
            attributes[.strokeWidth] = -5
        case .texture3:
            attributes[.foregroundColor] = color.withAlphaComponent(1.0)
            attributes[.strokeWidth] = -5
        }
        
        let attributedString = NSAttributedString(string: buttonText, attributes: attributes)
        
//        let attributes: [NSAttributedStringKey: Any] = [
//            .strokeWidth : 5.0,
//            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//        ]
//        let attributedString = NSAttributedString(string: "Flips: \(game.numFlips)", attributes: attributes)
//        flipCountLabel.attributedText = attributedString
        
        return attributedString
    }
    
    private func updateViewFromModel() {
        let cardSlotsFlipped = deck.cardSlotsFlipped
        for index in cardButtons[..<cardSlotsFlipped].indices {
            let button = cardButtons[index]
            let card = deck.cards[index]
            button.setAttributedTitle(getCardFace(card: card), for: UIControlState.normal)
        }
        for index in cardButtons[cardSlotsFlipped...].indices {
            let button = cardButtons[index]
            button.isHidden = true
        }
    }


}

