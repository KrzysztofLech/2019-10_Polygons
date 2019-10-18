//
//  RippleButton.swift
//  Polygons
//
//  Created by Krzysztof Lech on 18/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class RippleButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable private var sound: Bool = true
    
    private let soundId: SystemSoundID = 1104
    
    // MARK:- Init metod
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = cornerRadius
    }
    
    // MARK:- Touch metods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if sound { AudioServicesPlaySystemSound(soundId) }
        outlineAnimation()
    }
    
    // MARK:- Animation metod

    private func outlineAnimation() {
        let outlineColor = backgroundColor ?? UIColor.white

        let subLayer = CALayer()
        subLayer.frame = self.bounds

        subLayer.backgroundColor = UIColor.clear.cgColor
        subLayer.borderColor = outlineColor.cgColor
        subLayer.borderWidth = 0
        subLayer.cornerRadius = cornerRadius

        layer.addSublayer(subLayer)


        let borderWidthAnim = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnim.fromValue = 20
        borderWidthAnim.toValue = 0

        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 1
        scaleAnim.toValue = 1.35

        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = 0

        let groupAnim = CAAnimationGroup()
        groupAnim.duration = 0.3
        groupAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        groupAnim.animations = [borderWidthAnim, scaleAnim, opacityAnim]

        subLayer.add(groupAnim, forKey: nil)
    }
}
