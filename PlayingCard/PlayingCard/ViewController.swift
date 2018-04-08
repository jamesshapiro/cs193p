//
//  ViewController.swift
//  PlayingCard
//
//  Created by James Shapiro on 4/7/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var deck = PlayingCardDeck()
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
    }

}

