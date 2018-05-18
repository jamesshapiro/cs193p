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
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0,
//                           startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath()
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0,
//                           startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.fillPath()
//        }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2 * bounds.width, y: bounds.midY))
        path.addCurve(to: CGPoint(x: 0.8 * bounds.width, y: 0.4 * bounds.height),
                      controlPoint1: CGPoint(x: 0.4 * bounds.width, y: 0.35 * bounds.height),
                      controlPoint2: CGPoint(x: 0.6 * bounds.width, y: 0.55 * bounds.height))
        path.addQuadCurve(to: CGPoint(x: 0.8 * bounds.width, y: 0.3 * bounds.height),
                          controlPoint: CGPoint(x: 0.85 * bounds.width, y: 0.35 * bounds.height))
        path.lineWidth = 2.0
        UIColor.black.setStroke()
        path.stroke()
    }

}
