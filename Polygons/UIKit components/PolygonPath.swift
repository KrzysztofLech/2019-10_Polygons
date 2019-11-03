//
//  PolygonPath.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class PolygonPath: UIBezierPath {
    
    private let sidesNumber: Int
    private let size: CGFloat
    private lazy var triangleCorrection: CGFloat = {
        return size * 0.05
    }()
    
    init(sidesNumber: Int, size: Double) {
        self.sidesNumber = sidesNumber
        self.size = CGFloat(size)
        super.init()
        
        createPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPath() {
        let points = getPointsForPath()
        points.enumerated().forEach { point in
            if point.offset == 0 {
                move(to: point.element)
            } else {
                addLine(to: point.element)
            }
        }
        close()
        
        if sidesNumber % 2 != 0 {
            let polygonHeight = calculatePolygonHeight()
            let offset = (size - polygonHeight) / 2
            apply(CGAffineTransform(translationX: 0, y: offset))
        }
    }
    
    private func getPointsForPath() -> [CGPoint] {
        let correction: CGFloat = sidesNumber == 3 ? triangleCorrection : 0
        let radius = size / 2 + correction
        let angleRadians = CGFloat.pi * 2 / CGFloat(sidesNumber)
        
        let initialPoint = CGPoint(x: size / 2, y: 0)
        var points: [CGPoint] = [initialPoint]
        
        for index in 1..<sidesNumber {
            let point = getPoint(radius: radius, angle: angleRadians * CGFloat(index))
            points.append(point)
        }
        return points
    }

    private func getPoint(radius: CGFloat, angle: CGFloat) -> CGPoint {
        let correction: CGFloat = sidesNumber == 3 ? triangleCorrection : 0
        
        let x = radius * sin(angle)
        let y = radius * cos(angle)
        return CGPoint(x: radius + x - correction, y: radius - y)
    }
    
    private func calculatePolygonHeight() -> CGFloat {
        let sideLenght = calculatePolygonSideLenght()
        var height = 0.0
        if sidesNumber % 2 == 0 {
            height = (2 * sideLenght) / (2 * tan(Double.pi / Double(sidesNumber)))
        } else {
            height = sideLenght / (2 * tan(Double.pi / 2 / Double(sidesNumber)))
        }
        
        return CGFloat(height)
    }
    
    private func calculatePolygonSideLenght() -> Double {
        let points = getPointsForPath()
        let xLenghth = points[0].x - points[1].x
        let yLenghth = points[0].y - points[1].y
        
        let xLenghthDouble = Double(xLenghth)
        let yLenghthDouble = Double(yLenghth)
        
        let sideLenght = sqrt(xLenghthDouble * xLenghthDouble + yLenghthDouble * yLenghthDouble)
        return sideLenght
    }
}
