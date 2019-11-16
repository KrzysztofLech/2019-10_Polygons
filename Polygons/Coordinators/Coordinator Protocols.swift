//
//  Coordinator Protocols.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/11/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

protocol Coordinator {
    func start()
}

protocol PolygonList: AnyObject {
    func presentPolygonList(_ personNumber: Int)
}

protocol PolygonDetails: AnyObject {
    func presentPolygonDetails(_ cellData: CellData)
}
