//
//  ListViewModel.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

final class ListViewModel {
    
    private let personsQuantity: Int
    var cellWidth = 0.0
    
    private lazy var persons: [Person] = {
        return generateData()
    }()
    
    init(personsQuantity: Int) {
        self.personsQuantity = personsQuantity
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
        
        let sidesNumber = Int(index / AppSettings.groupElementsNumber) + 3
        let backgroundColor = Colors.cellBackgroundColors[index % AppSettings.groupElementsNumber]
        return CellData(path: PolygonPath(sidesNumber: sidesNumber, size: cellWidth),
                        person: person,
                        backgroundColor: backgroundColor,
                        moveContent: index < AppSettings.groupElementsNumber,
                        sides: sidesNumber)
    }
}
