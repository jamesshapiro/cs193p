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
    // Number of cards currently on the board. Gets increased to 12
    // at the beginning of the game during setup.
    private var numberOfCardsOnBoard = 0
    // Cards that the player has tapped on and selected.
    private var selected = [UIButton]()
    
    // In player vs. computer mode, the computer uses this timer
    // to determine how much time the player has left to make a
    // move before the computer steps in and wins the round
    private weak var timer: Timer?
    
    // Boolean registering whether the computer or the human
    // identified the set. We use this to decide whether to
    // color a matched set green (if the human won) or orange
    // (otherwise)
    private var computerWonRound = false
    
    // Facial expression used to personify the computer to the player.
    @IBOutlet weak var computerFacialExpression: UILabel!
    @IBOutlet weak var dealThreeButton: UIButton!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var computerScore: UILabel!
    @IBOutlet weak var gameResult: UILabel!
    
    // Depending on how long it has been since the last round, the computer is
    // either "thinking" about it's next move, grinning in anticipation of
    // its impending move, or celebrating or mourning the result of the
    // just-concluded round. In reality, the computer "thinks" up its move
    // instantaneously when a semi-randomly set timer expires.
    enum ComputerFace: String {
        case thinking = "🤔"
        case anticipating = "😁"
        case laughing = "😂"
        case crying = "😢"
    }

    var computerEmotionalState: ComputerFace = .thinking {
        didSet {
            computerFacialExpression.text = computerEmotionalState.rawValue
        }
    }
    
    func setTimer(predeterminedDelay: TimeInterval? = nil) {
        let randomDelay = Double(arc4random_uniform(UInt32(240 / numberOfCardsOnBoard))) + 5
        let timeComputerSpendsThinking = predeterminedDelay ??  randomDelay
        timer = Timer.scheduledTimer(withTimeInterval: timeComputerSpendsThinking, repeats: false) {_ in
            switch self.computerEmotionalState {
            // After "contemplating" its next move, the computer has identified a set and
            // is now giving the human player a few seconds to move. If the player does
            // not select a set in that time, the computer will win the round and remove
            // its set from the board.
            case .thinking:
                self.computerEmotionalState = .anticipating
                self.setTimer(predeterminedDelay: 3.0)
            // After giving the human player a few seconds to move (during which time the
            // player did NOT successfully select a set), the computer is now swooping
            // in to make its move and win the round.
            case .anticipating:
                self.computerEmotionalState = .laughing
                // If there is a set of cards on the board: select them, increase the
                // computer's score, and highlight the computer-identified set in orange
                if let setOfCards = self.setGame.findASetOfCards() {
                    self.selected = setOfCards.map { self.cardButtons[$0] }
                    self.setGame.updatePlayerVsComputerScore(with: self.indicesOfSelectedButtons, forHuman: false)
                    self.computerWonRound = true
                    self.cardButtons.forEach {
                        $0.isEnabled = false
                    }
                    self.updateViewFromModel()
                    // Otherwise, there are two possibilities:
                    // (1.) Every card in the deck has been drawn and there are no
                    // more remaining sets left to be identified.
                    // (2.) Not every card has been drawn, but the only way more sets
                    // can be identified is by increasing the number of cards on the
                    // board by drawing three, one or more times.
                    // In either case, the score does not change and no sets are
                    // removed from the board. However, in case 1, the game is over
                    // and the player learns who won.
                } else {
                    if self.setGame.isOutOfCards {
                        if self.setGame.score > self.setGame.computerScore {
                            self.gameResult.text = "You won!"
                            self.computerEmotionalState = .crying
                        } else if self.setGame.score < self.setGame.computerScore {
                            self.gameResult.text = "You lost!"
                            self.computerEmotionalState = .laughing
                        } else {
                            self.gameResult.text = "You tied."
                            self.computerEmotionalState = .thinking
                        }
                        self.gameResult.isHidden = false
                        self.timer?.invalidate()
                        break
                    }
                }
                self.setTimer(predeterminedDelay: 3.0)
            // After celebrating its victory in the last round, the computer
            // now contemplates its next move for a random amount of time.
            // If the player has not pressed any buttons since the end of the
            // last round, the computer clears away the matched set and replaces
            // it with three new cards (if possible).
            case .laughing:
                self.computerEmotionalState = .thinking
                self.setTimer(predeterminedDelay: randomDelay)
                if self.selected.count == 3 {
                    self.updateViewFromModel(indicesReceivingNewCards: self.indicesOfSelectedButtons)
                    self.cardButtons.forEach {
                        $0.isEnabled = true
                    }
                }
            // After mourning its defeat in the last round, the computer
            // now contemplates its next move for a random amount of time.
            // If the player has not pressed any buttons since the end of
            // the last round, the computer clears away the selected set
            // and replaces it with three new cards (if possible).
            case .crying:
                if self.selected.count == 3 {
                    self.updateViewFromModel(indicesReceivingNewCards: self.indicesOfSelectedButtons)
                    self.cardButtons.forEach {
                        $0.isEnabled = true
                    }
                }
                self.computerEmotionalState = .thinking
                self.setTimer(predeterminedDelay: randomDelay)
            }
        }
    }
    
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
        return numberOfCardsOnBoard == cardButtons.count
    }
    

    
    @IBAction func startNewGame() {
        numberOfCardsOnBoard = 0
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
            numberOfCardsOnBoard += 3
            updateViewFromModel(indicesReceivingNewCards: Array(numberOfCardsOnBoard-3..<numberOfCardsOnBoard))
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
                self.computerEmotionalState = .crying
                setGame.updatePlayerVsComputerScore(with: indicesOfSelectedButtons, forHuman: true)
                setTimer(predeterminedDelay: 3.0)
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
        
        for index in cardButtons[..<numberOfCardsOnBoard].indices where !selected.contains(cardButtons[index]) {
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
