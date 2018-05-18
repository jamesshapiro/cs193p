//
//  SquigglyView.swift
//  GraphicalSet
//
//  Created by James Shapiro on 5/18/18.
//  Copyright © 2018 James Shapiro. All rights reserved.
//

import UIKit



class SquigglyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawSquiggly(startingPoint: CGPoint) {
        let x = startingPoint.x
        let y = startingPoint.y
        let squigglyCurve1Width = 0.6 * bounds.width
        let squigglyCurve1Height = 0.1 * bounds.height
        let squiggly1Dest = CGPoint(x: x + squigglyCurve1Width, y: y - squigglyCurve1Height)
        let curve1controlPoint1Width = 0.2 * bounds.width
        let curve1controlPoint1Height = -0.15 * bounds.height
        let curve1controlPoint1 = CGPoint(x: x + curve1controlPoint1Width, y: y + curve1controlPoint1Height)
        let curve1controlPoint2Width = 0.4 * bounds.width
        let curve1controlPoint2Height = 0.05 * bounds.height
        let curve1controlPoint2 = CGPoint(x: x + curve1controlPoint2Width, y: y + curve1controlPoint2Height)
        let squiggly2Dest = CGPoint(x: x + squigglyCurve1Width, y: y - 2 * squigglyCurve1Height)
        let squiggly2controlPoint = CGPoint(x: x + squigglyCurve1Width + 0.06 * bounds.width,
                                            y: y - 0.15 * bounds.height)
        let squiggly3Dest = CGPoint(x: x, y: y - squigglyCurve1Height)
        let squiggly3controlPoint1 = CGPoint(x: x + 0.4 * bounds.width, y: y - 0.025 * bounds.height)
        let squiggly3controlPoint2 = CGPoint(x: x + 0.2 * bounds.width, y: y - 0.225 * bounds.height)
        let squiggly4dest = CGPoint(x: x, y: y)
        let squiggly4controlPoint = CGPoint(x: x - 0.06 * bounds.width, y: y - 0.05 * bounds.height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addCurve(to: squiggly1Dest,
                      controlPoint1: curve1controlPoint1,
                      controlPoint2: curve1controlPoint2)
        path.addQuadCurve(to: squiggly2Dest,
                          controlPoint: squiggly2controlPoint)
        path.addCurve(to: squiggly3Dest,
                      controlPoint1: squiggly3controlPoint1,
                      controlPoint2: squiggly3controlPoint2)
        path.addQuadCurve(to: squiggly4dest,
                          controlPoint: squiggly4controlPoint)
        path.close()
        path.addClip()
        path.lineWidth = -5.0
        UIColor.black.setStroke()
        path.stroke()
    }

    override func draw(_ rect: CGRect) {
        let startingPoint = CGPoint(x: 0.2 * bounds.width, y: 0.5 * bounds.height)
        drawSquiggly(startingPoint: startingPoint)
        //        let startingPoint2 = CGPoint(x: 0.2 * bounds.width, y: 0.2 * bounds.height)
        //        drawSquiggly(startingPoint: startingPoint2)
        //        let startingPoint3 = CGPoint(x: 0.2 * bounds.width, y: 0.8 * bounds.height)
        //        drawSquiggly(startingPoint: startingPoint3)
        for i in 0..<Int(bounds.width) {
            let stripeWidth = CGFloat(8)
            if i % (Int(stripeWidth) * 2) == 0 {
                let eye = CGFloat(i)
                let newPath = UIBezierPath()
                newPath.move(to: CGPoint(x: eye, y: 0))
                newPath.addLine(to: CGPoint(x: eye, y: bounds.height))
                newPath.addLine(to: CGPoint(x: eye + stripeWidth, y: bounds.height))
                newPath.addLine(to: CGPoint(x: eye + stripeWidth, y: 0))
                newPath.close()
                UIColor.red.setFill()
                newPath.fill()
            }
        }
    }

}
