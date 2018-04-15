//
//  ViewController.swift
//  SetGame
//
//  Created by James Shapiro on 4/8/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var setGame: SetCardGame! = nil
    private var numShown = 0
    private var selected = [UIButton]()
    private var cheatSuggestions = [UIButton]()

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
        cheatSuggestions = [UIButton]()
        setGame = SetCardGame()
        cardButtons.forEach { $0.isHidden = true }
        cardButtons.forEach { $0.setTitle(nil, for: UIControlState.normal) }
        cardButtons.forEach { $0.setAttributedTitle(nil, for: UIControlState.normal) }
        for _ in 0..<4 {
            dealThree()
        }
        updateViewFromModel()
    }
    
    // Note: the cards on the board will always contain a set if there are 21 or more
    // of them (https://oeis.org/A090245)
    @IBAction func dealThree() {
        if setGame.cardsFormASet(with: indicesOfSelectedButtons) {
            updateViewFromModel(indicesReceivingNewCards: indicesOfSelectedButtons)
        } else {
            numShown += 3
            updateViewFromModel(indicesReceivingNewCards: Array(numShown-3..<numShown))
        }
    }
    
    @IBAction func cheat(_ sender: UIButton) {
        if setGame.cardsFormASet(with: indicesOfSelectedButtons) {
            updateViewFromModel(indicesReceivingNewCards: indicesOfSelectedButtons)
        }
        selected = [UIButton]()
        if let combo = setGame.findASetOfCards() {
            for item in combo {
                cheatSuggestions.append(cardButtons[item])
            }
        }
        updateViewFromModel()
    }

    
    @IBAction func touchCard(_ sender: UIButton) {
        //print(cardButtons.index(of: sender)!)
        if selected.count < 3 {
            if selected.contains(sender) {
                selected.remove(at: selected.index(of: sender)!)
                setGame.updateScore()
            } else {
                selected.append(sender)
                setGame.updateScore(with: indicesOfSelectedButtons)
            }
            if selected.count == 3 {
                cheatSuggestions = [UIButton]()
            }
        } else {
            // three cases: (1.) user selects a different card (select card)
            //              (2.) user selects a selected card that's part of a match (deselect card)
            //              (3.) user selects a selected card that's part of non-match (select card)
            var dontSelectTouchedCard = false
            if setGame.cardsFormASet(with: indicesOfSelectedButtons) {
                dontSelectTouchedCard = selected.contains(sender)
                updateViewFromModel(indicesReceivingNewCards: indicesOfSelectedButtons)
            }
            selected = dontSelectTouchedCard ? [UIButton]() : [sender]
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
            if setGame.isOutOfCards {
                flipIndices.forEach { cardButtons[$0].isHidden = true }
            } else {
                for index in flipIndices {
                    let card = setGame.getNextCard(forIndex: index)
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
        } else if setGame.cardsFormASet(with: indicesOfSelectedButtons) {
            selected.forEach { $0.layer.borderColor = UIColor.green.cgColor }
        } else {
            selected.forEach { $0.layer.borderColor = UIColor.red.cgColor }
        }
        score.text = "Score: \(setGame.score)"
        if setGame.isOutOfCards || (cardsSlotsAreAllInUse && !setGame.cardsFormASet(with: indicesOfSelectedButtons)) {
            dealThreeButton.isEnabled = false
        } else {
            dealThreeButton.isEnabled = true
        }
        for button in cheatSuggestions {
            if !selected.contains(button) {
                button.layer.borderColor = UIColor.orange.cgColor
            }
        }
    }
}
