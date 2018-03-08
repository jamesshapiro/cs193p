//
//  ViewController.swift
//  Concentration
//
//  Created by James Shapiro on 3/6/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    lazy var game: Concentration = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    @IBAction func startNewGame() {
        emojiChoices = getEmojiChoices()
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
    }
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        flipCountLabel.text = "Flips: \(game.numFlips)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    lazy var emojiChoices = getEmojiChoices()
    
    func getEmojiChoices() -> [String] {
        var emojiThemes = [[String]]()
        emojiThemes += [["🦇","😱","🙀","😈","🎃","👻","🍭","🍬","🍎"]]
        emojiThemes += [["🍆","🌶","🥐","🥕","🥖","🌭","🥑","🥦"]]
        emojiThemes += [["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🏓"]]
        emojiThemes += [["🐸","🦊","🐰","🐨","🐶","🐵","🦁","🐷"]]
        emojiThemes += [["🇧🇧","🇧🇸","🇦🇿","🇻🇬","🇬🇷","🇯🇵","🇿🇦","🇺🇸"]]
        emojiThemes += [["⌚️","⏱","⏲","⏰","🕰","⌛️","⏳","📅"]]
        let randomIndex = Int(arc4random_uniform(UInt32(emojiThemes.count)))
        return emojiThemes[randomIndex]
        
    }
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}

