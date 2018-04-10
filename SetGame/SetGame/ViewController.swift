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

    override func viewDidLoad() {
        super.viewDidLoad()
        cardButtons.forEach { $0.layer.borderWidth = 3.0 }
        cardButtons.forEach { $0.layer.cornerRadius = 8.0 }
        startNewGame()
    }

    private var indicesOfSelectedButtons: [Int] {
        return selected.map { cardButtons.index(of: $0)! }
    }
    private var cardsSlotsAreAllInUse: Bool {
        return numShown == cardButtons.count
    }
    
    @IBOutlet weak var dealThreeButton: UIButton!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var score: UILabel!
    @IBAction func startNewGame() {
        numShown = 0
        selected = [UIButton]()
        deck = PlayingCardDeck()
        cardButtons.forEach { $0.isHidden = true }
        cardButtons.forEach { $0.setTitle(nil, for: UIControlState.normal) }
        cardButtons.forEach { $0.setAttributedTitle(nil, for: UIControlState.normal) }
        for _ in 0..<4 {
            dealThree()
        }
        updateViewFromModel()
    }
    
    @IBAction func dealThree() {
        if deck.cardsFormASet(with: indicesOfSelectedButtons) {
            updateViewFromModel(indicesReceivingNewCards: indicesOfSelectedButtons)
        } else {
            numShown += 3
            updateViewFromModel(indicesReceivingNewCards: Array(numShown-3..<numShown))
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if selected.count < 3 {
            if selected.contains(sender) {
                selected.remove(at: selected.index(of: sender)!)
                deck.updateScore()
            } else {
                selected.append(sender)
                deck.updateScore(with: indicesOfSelectedButtons)
            }
        } else {
            // three cases: (1.) user selects a different card (select card)
            //              (2.) user selects a selected card that's part of a match (deselect card)
            //              (3.) user selects a selected card that's part of non-match (select card)
            var dontSelectNewCard = false
            if deck.cardsFormASet(with: indicesOfSelectedButtons) {
                dontSelectNewCard = selected.contains(sender)
                updateViewFromModel(indicesReceivingNewCards: indicesOfSelectedButtons)
            }
            selected = dontSelectNewCard ? [UIButton]() : [sender]
        }
        updateViewFromModel()
    }
    
    private func getCardFace(card: PlayingCard) -> NSAttributedString {
        let buttonSymbol = ["▲", "●", "■"][card.shape.rawValue]
        let buttonText = String(repeating: buttonSymbol, count: card.pipCount.rawValue)
        let color = [UIColor.red, UIColor.green, UIColor.blue][card.color.rawValue]
        let attributes: [NSAttributedStringKey: Any] = [
            [.strokeWidth: 5, .foregroundColor: color.withAlphaComponent(1.0)],
            [.strokeWidth: -5, .foregroundColor: color.withAlphaComponent(0.15)],
            [.strokeWidth: -5, .foregroundColor: color.withAlphaComponent(1.0)]
        ][card.fill.rawValue]
        let attributedString = NSAttributedString(string: buttonText, attributes: attributes)
        return attributedString
    }
    
    private func updateViewFromModel(indicesReceivingNewCards: [Int]? = nil) {
        if let flipIndices = indicesReceivingNewCards {
            if deck.isOutOfCards {
                flipIndices.forEach { cardButtons[$0].isHidden = true }
            } else {
                for index in flipIndices {
                    let card = deck.getNextCard(forIndex: index)
                    let button = cardButtons[index]
                    button.setAttributedTitle(getCardFace(card: card), for: UIControlState.normal)
                    button.layer.borderColor = UIColor.gray.cgColor
                    button.isHidden = false
                }
                selected = [UIButton]()
            }
        }
        
        for index in cardButtons[..<numShown].indices where !selected.contains(cardButtons[index]) {
            cardButtons[index].layer.borderColor = UIColor.gray.cgColor
        }
        
        if selected.count < 3 {
            selected.forEach { $0.layer.borderColor = UIColor.blue.cgColor }
        } else if deck.cardsFormASet(with: indicesOfSelectedButtons) {
            selected.forEach { $0.layer.borderColor = UIColor.green.cgColor }
        } else {
            selected.forEach { $0.layer.borderColor = UIColor.red.cgColor }
        }
        score.text = "Score: \(deck.score)"
        if deck.isOutOfCards || (cardsSlotsAreAllInUse && !deck.cardsFormASet(with: indicesOfSelectedButtons)) {
            dealThreeButton.isEnabled = false
        } else {
            dealThreeButton.isEnabled = true
        }
    }
}
