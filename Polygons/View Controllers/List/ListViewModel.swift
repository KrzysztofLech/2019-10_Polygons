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
        
        return CellData(path: getPath(forIndex: index),
                        person: person,
                        backgroundColor: getCellBackgroundColor(forIndex: index),
                        moveContent: index < Constants.polygonGroupValue)
    }
    
    private func getPath(forIndex index: Int) -> UIBezierPath {
        let sideNumber = Int(index / Constants.polygonGroupValue) + 3
        
        return PolygonPath(sidesNumber: sideNumber, size: cellSize.width)
    }
    
    private func getCellBackgroundColor(forIndex index: Int) -> UIColor {
        return UIColor.white
    }
}
