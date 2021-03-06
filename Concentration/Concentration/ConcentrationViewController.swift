//
//  ViewController.swift
//  Concentration
//
//  Created by James Shapiro on 3/6/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController
{

    let themes = [
        "Halloween": (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),"🦇😱🙀😈🎃👻🍭🍬🍎"),
        "Food": (#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),"🍆🌶🥐🥕🥖🌭🥑🥦"),
        "Sports": (#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),"⚽️🏀🏈⚾️🎾🏐🏉🏓"),
        "Animals": (#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1),"🐸🦊🐰🐨🐶🐵🦁🐷"),
        "Flags": (#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.0329692848, green: 0.1491458118, blue: 0.9773867726, alpha: 1),"🇧🇧🇧🇸🇦🇿🇻🇬🇬🇷🇯🇵🇿🇦🇺🇸"),
        "Time": (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),"⌚️⏱⏲⏰🕰⌛️⏳📅")
    ]
    
    var themeKey: String? {
        didSet {
            theme = themes[themeKey!]!
        }
    }
    
    var theme: (UIColor, UIColor, String)? {
        didSet {
            let (backgroundColor, cardColor, emojiSet) = theme!
            self.view.backgroundColor = backgroundColor
            cardBackgroundColor = cardColor
            emojis = emojiSet
            emoji = [:]
            updateViewFromModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateViewFromModel()
    }
    
    var emojis: String! = nil
    var cardBackgroundColor: UIColor! = nil
    private var game: Concentration! = nil

    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBAction func startNewGame() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        theme = themes[themeKey!]!
        updateViewFromModel()
    }

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!

    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = cardBackgroundColor
                } else {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackgroundColor
                }
            }
            flipCountLabel.text = "Flips: \(game.numFlips)"
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    
    private var emoji = [Card:String]()
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojis.count > 0 {
            let randomStringIndex = emojis.index(emojis.startIndex, offsetBy: emojis.count.arc4random)
            emoji[card] = String(emojis.remove(at: randomStringIndex))
            }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
