//
//  ListViewModel.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class ListViewModel {
    
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
        for index in 0..<personsQuantity {
            persons.append(Person(id: index))
        }
        return persons
    }
    
    func getCellData(forIndex index: Int) -> CellData? {
        guard let person = persons[safe: index] else { return nil }
        
        return CellData(path: getPath(forIndex: index),
                        person: person,
                        backgroundColor: getCellBackgroundColor(forIndex: index))
    }
    
    private func getPath(forIndex index: Int) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height))
        return path
    }
    
    private func getCellBackgroundColor(forIndex index: Int) -> UIColor {
        return UIColor.white
    }
}
