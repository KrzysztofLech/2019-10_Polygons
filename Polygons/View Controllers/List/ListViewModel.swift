//
//  ListViewModel.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class ListViewModel {
    
    private enum Constants {
        static let polygonGroupValue: Int = 5
    }

    private let personsQuantity: Int
    private let cellSize: CGSize
    
    private lazy var persons: [Person] = {
        return generateData()
    }()
    
    init(personsQuantity: Int, cellSize: CGSize) {
        self.personsQuantity = personsQuantity
        self.cellSize = cellSize
    }
    
    private func generateData() -> [Person] {
        var persons: [Person] = []
        for index in 1...personsQuantity {
            persons.append(Person(id: index))
        }
        return persons
    }
    
    func getCellData(forIndex index: Int) -> CellData? {
        guard let person = persons[safe: index] else { return nil }
        
        let sidesNumber = Int(index / Constants.polygonGroupValue) + 3
        return CellData(index: index,
                        path: getPath(forSidesNumber: sidesNumber),
                        person: person,
                        backgroundColor: getCellBackgroundColor(forIndex: index),
                        moveContent: index < Constants.polygonGroupValue,
                        sides: sidesNumber)
    }
    
    private func getPath(forSidesNumber sides: Int) -> UIBezierPath {
        return PolygonPath(sidesNumber: sides, size: cellSize.width)
    }
    
    private func getCellBackgroundColor(forIndex index: Int) -> UIColor {
        let indexValue = index % Constants.polygonGroupValue + 1
        
        switch indexValue {
        case 1: return UIColor.red
        case 2: return UIColor.white
        case 3: return Colors.color1
        case 4: return UIColor.green
        case 5: return UIColor.blue
        default: return UIColor.clear
        }
        
        // version 2: one color shades
        //
        // let alphaValue = 0.2 * CGFloat(indexValue)
        // let color = Colors.color1
        // return color.withAlphaComponent(alphaValue)
    }
}
