//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by James Shapiro on 4/12/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    // MARK: - Navigation
    
    let themes = [ //(UIColor, UIColor, String) {
        "Halloween": (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),"🦇😱🙀😈🎃👻🍭🍬🍎"),
        "Food": (#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),"🍆🌶🥐🥕🥖🌭🥑🥦"),
        "Sports": (#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),"⚽️🏀🏈⚾️🎾🏐🏉🏓"),
        "Animals": (#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1),"🐸🦊🐰🐨🐶🐵🦁🐷"),
        "Flags": (#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.0329692848, green: 0.1491458118, blue: 0.9773867726, alpha: 1),"🇧🇧🇧🇸🇦🇿🇻🇬🇬🇷🇯🇵🇿🇦🇺🇸"),
        "Time": (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),"⌚️⏱⏲⏰🕰⌛️⏳📅")
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                (segue.destination as! ConcentrationViewController).theme = theme
            }
        }
    }
}
