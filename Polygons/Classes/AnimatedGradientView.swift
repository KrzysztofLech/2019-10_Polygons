//
//  AnimatedGradientView.swift
//  Polygons
//
//  Created by Krzysztof Lech on 17/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

@IBDesignable
final class AnimatedGradientView: UIView {
    
    @IBInspectable var colour1: UIColor = .white
    @IBInspectable var colour2: UIColor = .black
    
    private let gradientLayer = CAGradientLayer()
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
        
    private func setup() {
        gradientLayer.colors = [
            colour1.cgColor,
            colour2.cgColor,
            colour1.cgColor,
            colour2.cgColor,
            colour1.cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientLayer.locations = locations as [NSNumber]?
        
        
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        gradientLayer.frame = CGRect( x: -viewWidth,
                                      y: 0,
                                      width: viewWidth * 2,
                                      height: viewHeight)
        layer.addSublayer(gradientLayer)
    }
    
    func startAnimation() {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientAnimation.toValue   = [0.5, 0.75, 1.0, 1.25, 1.5]
        gradientAnimation.duration = 20.0
        gradientAnimation.repeatCount = Float.infinity

        gradientLayer.add(gradientAnimation, forKey: nil)
    }
    
    func refreshGradient() {
        gradientLayer.removeFromSuperlayer()
        setup()
    }
}
