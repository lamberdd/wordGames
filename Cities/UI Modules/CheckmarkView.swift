//
//  CheckmarkView.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/26/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class CheckmarkView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var path: UIBezierPath!
    var pathLayer: CAShapeLayer!
    var animation: CABasicAnimation!
    
    override func awakeFromNib() {
        
        let frameWidth = self.frame.width
        let frameHeight = self.frame.height
        
        let firstPoint = CGPoint(x: frameWidth/3, y: frameHeight/2)
        let secondPoint = CGPoint(x: frameWidth/2, y: (frameHeight*2)/3)
        let thirdPoint = CGPoint(x: (frameWidth*3)/4, y: frameHeight/3)
        
        path = UIBezierPath()
        
        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        
        pathLayer = CAShapeLayer()
        pathLayer.path = path.cgPath
        pathLayer.strokeEnd = 1
        pathLayer.lineWidth = 2
        pathLayer.strokeColor = Constants.colors.main.cgColor
        pathLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(pathLayer)
        
        animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        animation.repeatCount = 1
        
        self.alpha = 0.0
        backgroundColor = UIColor.clear
    }
    
    func show(animate: Bool) {
        alpha = 1.0
        pathLayer.add(animation, forKey: "line")
        UIView.animate(withDuration: 1, delay: animation.duration, options: [], animations: {
            self.alpha = 0.0
        }) { (complete) in
            //self.pathLayer.removeAnimation(forKey: "line")
        }
    }

}
