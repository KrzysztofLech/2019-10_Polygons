//
//  WavePath.swift
//  Polygons
//
//  Created by Krzysztof Lech on 20/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

enum PathPhase {
    case start, end
}

final class WavePath: UIBezierPath {
    
    private var waveHeight: CGFloat = 10
    private let waveModificationValue = CGFloat.random(in: 5...15)
    
    private var height: CGFloat = {
        return UIScreen.main.bounds.height
    }()
        
    init(phase: PathPhase) {
        super.init()
        
        createPath(forPhase: phase)
        firPathToDevice()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPath(forPhase phase: PathPhase) {
        let offset = phase == .start ? 0.0 : height
        if phase == .end {
            waveHeight *= waveModificationValue
        }
        
        move(to: CGPoint(x: 0, y: waveHeight/2 + offset))
        addCurve(to: CGPoint(x: 50, y: 0 + offset),
                 controlPoint1: CGPoint(x: 0, y: waveHeight/2 + offset),
                 controlPoint2: CGPoint(x: 25, y: 0 + offset))
        addCurve(to: CGPoint(x: 150, y: waveHeight + offset),
                 controlPoint1: CGPoint(x: 75, y: 0 + offset),
                 controlPoint2: CGPoint(x: 100, y: waveHeight + offset))
        addCurve(to: CGPoint(x: 250, y: 0 + offset),
                 controlPoint1: CGPoint(x: 200, y: waveHeight + offset),
                 controlPoint2: CGPoint(x: 200, y: 0 + offset))
        addCurve(to: CGPoint(x: 350, y: waveHeight + offset),
                 controlPoint1: CGPoint(x: 300, y: 0 + offset),
                 controlPoint2: CGPoint(x: 325, y: waveHeight + offset))
        addCurve(to: CGPoint(x: 400, y: waveHeight/2 + offset),
                 controlPoint1: CGPoint(x: 375, y: waveHeight + offset),
                 controlPoint2: CGPoint(x: 400, y: waveHeight/2 + offset))
        addLine(to: CGPoint(x: 400, y: height))
        addLine(to: CGPoint(x: 0, y: height))

        close()
    }
    
    private func firPathToDevice() {
        let width = UIScreen.main.bounds.width
        let aspect = width / 400
        let transform = CGAffineTransform(scaleX: aspect, y: 1)
        apply(transform)
    }
}
