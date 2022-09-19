//
//  CircularProgressView.swift
//  Dryve Customer App
//
//  Created by Asad Hussain on 10/02/2020.
//  Copyright © 2020 Asad Hussain. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    var progressLyr = CAShapeLayer()
    var trackLyr = CAShapeLayer()
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       makeCircularPath()
    }
    var progressClr = UIColor.white {
       didSet {
          progressLyr.strokeColor = progressClr.cgColor
       }
    }
    var trackClr = UIColor.white {
       didSet {
          trackLyr.strokeColor = trackClr.cgColor
       }
    }
    func makeCircularPath() {
       self.backgroundColor = UIColor.clear
       self.layer.cornerRadius = self.frame.size.width/2
       let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
       trackLyr.path = circlePath.cgPath
       trackLyr.fillColor = UIColor.clear.cgColor
       trackLyr.strokeColor = trackClr.cgColor
       trackLyr.lineWidth = 6.0
       trackLyr.strokeEnd = 1.0
       layer.addSublayer(trackLyr)
       progressLyr.path = circlePath.cgPath
       progressLyr.fillColor = UIColor.clear.cgColor
       progressLyr.strokeColor = progressClr.cgColor
       progressLyr.lineWidth = 6.0
       progressLyr.strokeEnd = 0.0
       layer.addSublayer(progressLyr)
    }
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
       let animation = CABasicAnimation(keyPath: "strokeEnd")
       animation.duration = duration
       animation.fromValue = 0
       animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
       progressLyr.strokeEnd = CGFloat(value)
       progressLyr.add(animation, forKey: "animateprogress")
    }

}

class AnimationCustomView: UIView {
    enum Direction: Int {
        case FromLeft = 0
        case FromRight = 1
    }

    @IBInspectable var direction : Int = 0
    @IBInspectable var delay :Double = 0.0
    @IBInspectable var duration :Double = 0.0
    override func layoutSubviews() {
        initialSetup()
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            if let superview = self.superview {
                           if self.direction == Direction.FromLeft.rawValue {
                               self.center.x += superview.bounds.width
                           } else {
                               self.center.x -= superview.bounds.width
                           }
                       }
        })
    }
    func initialSetup() {
        if let superview = self.superview {
            if direction == Direction.FromLeft.rawValue {
             self.center.x -= superview.bounds.width
            } else {
                self.center.x += superview.bounds.width
            }

        }
    }
}
