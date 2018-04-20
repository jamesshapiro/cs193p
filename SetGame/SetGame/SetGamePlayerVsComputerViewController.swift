//
//  SetGamePlayerVsComputerViewController.swift
//  SetGame
//
//  Created by James Shapiro on 4/15/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class SetGamePlayerVsComputerViewController: UIViewController {
    private var setGame: SetCardGame! = nil
    private var numShown = 0
    private var selected = [UIButton]()
    private weak var timer: Timer?
    private var computerWonRound = false
    
    @IBOutlet weak var computerFacialExpression: UILabel!
    @IBOutlet weak var dealThreeButton: UIButton!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var computerScore: UILabel!
    @IBOutlet weak var gameResult: UILabel!
    
    var computerFace: ComputerFace = .thinking {
        didSet {
            computerFacialExpression.text = computerFace.rawValue
        }
    }
    
    func setTimer(interval: TimeInterval? = nil) {
        let thonkingTime = Double(arc4random_uniform(UInt32(240 / numShown))) + 5
        let thinkingTime = interval ??  thonkingTime
        timer = Timer.scheduledTimer(withTimeInterval: thinkingTime, repeats: false) {_ in
            switch self.computerFace {
            case .thinking:
                self.computerFace = .anticipating
                self.setTimer(interval: 3.0)
            case .anticipating:
                self.computerFace = .laughing
                if let setOfCards = self.setGame.findASetOfCards() {
                    self.selected = setOfCards.map { self.cardButtons[$0] }
                    self.setGame.updatePlayerVsComputerScore(with: self.indicesOfSelectedButtons, forHuman: false)
                } else {
                    if self.setGame.isOutOfCards {
                        if self.setGame.score > self.setGame.computerScore {
                            self.gameResult.text = "You won!"
                            self.computerFace = .crying
                        } else if self.setGame.score < self.setGame.computerScore {
                            self.gameResult.text = "You lost!"
                            self.computerFace = .laughing
                        } else {
                            self.gameResult.text = "You tied."
                            self.computerFace = .thinking
                        }
                        self.gameResult.isHidden = false
                        self.timer?.invalidate()
                        break
                    }
                }
                
                self.computerWonRound = true
                self.cardButtons.forEach {
                    $0.isEnabled = false
                }
                self.updateViewFromModel()
                self.setTimer(interval: 3.0)
            case .laughing:
                self.setTimer(interval: thonkingTime)
                if self.selected.count == 3 {
                    self.updateViewFromModel(indicesReceivingNewCards: self.indicesOfSelectedButtons)
                    self.cardButtons.forEach {
                        $0.isEnabled = true
                    }
                }
                self.computerFace = .thinking
            case .crying:
                if self.selected.count == 3 {
                    self.updateViewFromModel(indicesReceivingNewCards: self.indicesOfSelectedButtons)
                    self.cardButtons.forEach {
                        $0.isEnabled = true
                    }
                }
                self.computerFace = .thinking
                self.setTimer(interval: thonkingTime)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardButtons.forEach { $0.layer.borderWidth = 3.0 }
        cardButtons.forEach { $0.layer.cornerRadius = 8.0 }
        startNewGame()
    }
    
    enum ComputerFace: String {
        case thinking = "🤔"
        case anticipating = "😁"
        case laughing = "😂"
        case crying = "😢"
    }
    
    private var indicesOfSelectedButtons: [Int] {
        return selected.map { cardButtons.index(of: $0)! }
    }
    
    private var cardsSlotsAreAllInUse: Bool {
        return numShown == cardButtons.count
    }
    

    
    @IBAction func startNewGame() {
        numShown = 0
        selected = [UIButton]()
        setGame = SetCardGame()
        cardButtons.forEach { $0.isHidden = true }
        cardButtons.forEach { $0.setTitle(nil, for: UIControlState.normal) }
        cardButtons.forEach { $0.setAttributedTitle(nil, for: UIControlState.normal) }
        for _ in 0..<4 {
            dealThree()
        }
        updateViewFromModel()
        setTimer()
        gameResult.isHidden = true
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
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        //print(cardButtons.index(of: sender)!)
        if selected.count < 3 {
            if selected.contains(sender) {
                selected.remove(at: selected.index(of: sender)!)
            } else {
                selected.append(sender)
            }
            if selected.count == 3, setGame.cardsFormASet(with: indicesOfSelectedButtons) {
                timer?.invalidate()
                self.computerFace = .crying
                setGame.updatePlayerVsComputerScore(with: indicesOfSelectedButtons, forHuman: true)
                setTimer(interval: 3.0)
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
            if computerWonRound {
                selected.forEach {$0.layer.borderColor = UIColor.orange.cgColor}
            } else {
                selected.forEach { $0.layer.borderColor = UIColor.green.cgColor }
            }
        } else {
            selected.forEach { $0.layer.borderColor = UIColor.red.cgColor }
        }
        score.text = "Score: \(setGame.score)"
        computerScore.text = "Score \(setGame.computerScore)"
        if setGame.isOutOfCards || (cardsSlotsAreAllInUse && !setGame.cardsFormASet(with: indicesOfSelectedButtons)) {
            dealThreeButton.isEnabled = false
        } else {
            dealThreeButton.isEnabled = true
        }
        computerWonRound = false
    }
}
