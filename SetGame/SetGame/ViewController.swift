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
    var numShown = 0
    var selected = [UIButton]()
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var score: UILabel!
    @IBAction func startNewGame() {
        numShown = 0
        selected = [UIButton]()
        deck = PlayingCardDeck()
        cardButtons.forEach { $0.isHidden = true }
        cardButtons.forEach { $0.setTitle(nil, for: UIControlState.normal) }
        for _ in 0..<4 {
            dealThree()
        }
        updateViewFromModel(flipSelected: false, selectedIndices: [])
    }
    
    func replaceIfMatching() {
        if selected.count == 3 {
            let cardNumbers = selected.map { cardButtons.index(of: $0)! }
            if deck.cardsFormASet(indices: cardNumbers) {
                updateViewFromModel(flipSelected: true, selectedIndices: cardNumbers)
            }
        }
    }
    
    @IBAction func dealThree() {
        let numSelected = selected.count
        replaceIfMatching()
        if numSelected > selected.count {
            return
        }
        if numShown < 24 {
            updateViewFromModel(flipSelected: true, selectedIndices: Array(numShown..<numShown+3))
            numShown += 3
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if selected.contains(sender) {
            if selected.count < 3 {
                selected.remove(at: selected.index(of: sender)!)
            }
        } else if selected.count < 3 {
            selected.append(sender)
        } else {
            replaceIfMatching()
            selected = [sender]
        }
        updateViewFromModel(flipSelected: false, selectedIndices: [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    func getCardFace(card: PlayingCard) -> NSAttributedString {
        // TODO: use rawValues to index into an array of options instead.
        var attributes = [NSAttributedStringKey: Any]()
        var buttonText = ""
        var color: UIColor! = nil
        
        switch card.shape {
        case .shape1: buttonText = "▲"
        case .shape2: buttonText = "●"
        case .shape3: buttonText = "■"
        }
        
        buttonText = String(repeating: buttonText, count: card.pipCount)
        
        switch card.color {
        case .color1: color = UIColor.red
        case .color2: color = UIColor.green
        case .color3: color = UIColor.blue
        }
        
        attributes[.strokeWidth] = -5
        attributes[.foregroundColor] = color.withAlphaComponent(1.0)
        switch card.fill {
        case .texture1:
            attributes[.strokeWidth] = 5
        case .texture2:
            attributes[.foregroundColor] = color.withAlphaComponent(0.15)
        case .texture3:
            break
        }
        
        let attributedString = NSAttributedString(string: buttonText, attributes: attributes)
        return attributedString
    }
    
    private func updateViewFromModel(flipSelected: Bool, selectedIndices: [Int]) {
        if flipSelected {
            guard deck.cardsFlippedSoFar < deck.cards.count else {
                selectedIndices.forEach { cardButtons[$0].isHidden = true }
                return
            }
            for index in selectedIndices {
                let button = cardButtons[index]
                let card = deck.getNextCard(forIndex: index)
                button.setAttributedTitle(getCardFace(card: card), for: UIControlState.normal)
                button.layer.borderWidth = 3.0
                button.layer.cornerRadius = 8.0
                button.layer.borderColor = UIColor.gray.cgColor
                button.isHidden = false
            }
            selected = [UIButton]()
            return
        }
        
        for index in cardButtons[..<numShown].indices {
            if !selected.contains(cardButtons[index]) {
                cardButtons[index].layer.borderColor = UIColor.gray.cgColor
            }
        }
        if selected.count < 3 {
            selected.forEach { $0.layer.borderColor = UIColor.blue.cgColor }
        } else if deck.cardsFormASet(indices: selected.map { cardButtons.index(of: $0)! }) {
            selected.forEach { $0.layer.borderColor = UIColor.green.cgColor }
        } else {
            selected.forEach { $0.layer.borderColor = UIColor.red.cgColor }
        }
        score.text = "Score: \(deck.score)"
        print(deck.cardsMatchedSoFar)
        
        if deck.cardsMatchedSoFar == deck.cards.count, selected.count == 3,
            deck.cardsFormASet(indices: selected.map { cardButtons.index(of: $0)! }) {
            selected.forEach { $0.isHidden = true }
        }
    }
}
