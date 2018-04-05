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
    // TODO: fix variable names (esp for themes)
    // TODO: implement a timer-based bonus
    // TODO: use viewdidload, etc.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    var emojis: [String]! = nil
    var game: Concentration! = nil
    var cardBackgroundColor: UIColor! = nil
    
    @IBAction func startNewGame() {
        let themeAndEmojis = getThemeAndEmojis()
        self.view.backgroundColor = themeAndEmojis.0
        cardBackgroundColor = themeAndEmojis.1
        emojis = themeAndEmojis.2
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
                button.backgroundColor = cardBackgroundColor
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackgroundColor
            }
        }
        flipCountLabel.text = "Flips: \(game.numFlips)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    func getThemeAndEmojis() -> (UIColor, UIColor, [String]) {
        var themeEmojiTuples = [(UIColor, UIColor, [String])]()
        themeEmojiTuples += [(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),["🦇","😱","🙀","😈","🎃","👻","🍭","🍬","🍎"])]
        themeEmojiTuples += [(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),["🍆","🌶","🥐","🥕","🥖","🌭","🥑","🥦"])]
        themeEmojiTuples += [(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🏓"])]
        themeEmojiTuples += [(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1),["🐸","🦊","🐰","🐨","🐶","🐵","🦁","🐷"])]
        themeEmojiTuples += [(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.0329692848, green: 0.1491458118, blue: 0.9773867726, alpha: 1),["🇧🇧","🇧🇸","🇦🇿","🇻🇬","🇬🇷","🇯🇵","🇿🇦","🇺🇸"])]
        themeEmojiTuples += [(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),["⌚️","⏱","⏲","⏰","🕰","⌛️","⏳","📅"])]
        let randomIndex = Int(arc4random_uniform(UInt32(themeEmojiTuples.count)))
        return themeEmojiTuples[randomIndex]
        
    }
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        
        if emoji[card.identifier] == nil, emojis.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
            emoji[card.identifier] = emojis.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}

