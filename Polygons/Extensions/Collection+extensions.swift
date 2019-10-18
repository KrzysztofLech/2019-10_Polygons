//
//  Collection+extensions.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
