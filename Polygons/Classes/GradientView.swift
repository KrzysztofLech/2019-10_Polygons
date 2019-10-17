//
//  GradientView.swift
//  Polygons
//
//  Created by Krzysztof Lech on 17/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = .white
    @IBInspectable var middleColor: UIColor = .gray
    @IBInspectable var bottomColor: UIColor = .black
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        let colors = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.0, 0.5, 1.0]

        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: colorLocations)
            else { return }

        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)

        context?.drawLinearGradient(gradient,
                                    start: startPoint,
                                    end: endPoint,
                                    options: [])
    }
}
