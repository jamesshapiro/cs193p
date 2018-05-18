//
//  PlayingCardView.swift
//  GraphicalSet
//
//  Created by James Shapiro on 5/16/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {    
    override func draw(_ rect: CGRect) {
        for vw in subviews {
            vw.removeFromSuperview()
        }
        let squigView = SquigglyView(frame: CGRect(x: 0.33 * bounds.width,
                                                   y: 0 * bounds.height,
                                                   width: 0.33 * bounds.width, height: 0.33 * bounds.height))
        let squigView2 = SquigglyView(frame: CGRect(x: 0.33 * bounds.width,
                                                   y: 0.33 * bounds.height,
                                                   width: 0.33 * bounds.width, height: 0.33 * bounds.height))
        let squigView3 = SquigglyView(frame: CGRect(x: 0.33 * bounds.width,
                                                   y: 0.66 * bounds.height,
                                                   width: 0.33 * bounds.width, height: 0.33 * bounds.height))
        self.addSubview(squigView)
        self.addSubview(squigView2)
        self.addSubview(squigView3)
    }
}
