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
    var numSelected = 0
    var selected = [UIButton]()

    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var dealThree: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if selected.count < 3  {
            if selected.contains(sender) {
                sender.layer.borderColor = UIColor.gray.cgColor
                selected.remove(at: selected.index(of: sender)!)
            } else {
                sender.layer.borderColor = UIColor.blue.cgColor
                selected.append(sender)
            }
            let cardNumbers = selected.map {cardButtons.index(of: $0)! }
            if selected.count == 3 {
                if deck.checkIfSetAndReplace(indices: cardNumbers) {
                    selected.forEach { $0.layer.borderColor = UIColor.green.cgColor }
                } else {
                    selected.forEach { $0.layer.borderColor = UIColor.red.cgColor }
                }
            }
            return
        }
        guard !selected.contains(sender) else {
            return
        }
        let cardNumbers = selected.map({cardButtons.index(of: $0)!})
        let isSet = deck.checkIfSetAndReplace(indices: cardNumbers)
        print(isSet)
        for c in selected {
            c.layer.borderColor = UIColor.gray.cgColor
        }
        selected = [UIButton]()
        
        
//        if let cardNumber = cardButtons.index(of: sender) {
//            game.chooseCard(at: cardNumber)
//            updateViewFromModel()
//        } else {
//            print("chosen card was not in cardButtons")
//        }
        
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
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.cornerRadius = 4.0
            if index < cardSlotsFlipped {
                let card = deck.cards[index]
                button.setAttributedTitle(getCardFace(card: card), for: UIControlState.normal)
            } else {
                button.isHidden = true
            }
        }
    }


}

