//
//  MainCoordinator.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/11/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    private let window: UIWindow
    private let startViewController: StartViewController
    private var listViewController: ListViewController?
    private var detailsTransition: DetailsTransition?
    
    init(window: UIWindow) {
        self.window = window
        self.startViewController = StartViewController()
    }
    
    func start() {
        startViewController.coordinator = self
        window.rootViewController = startViewController
        window.makeKeyAndVisible()
    }
}

extension MainCoordinator: PolygonList {
    func presentPolygonList(_ personNumber: Int) {
        let listViewController = ListViewController(personNumber: personNumber)
        self.listViewController = listViewController
        listViewController.modalPresentationStyle = .fullScreen
        listViewController.modalTransitionStyle = .crossDissolve
        listViewController.coordinator = self
        startViewController.present(listViewController, animated: true)
    }
}

extension MainCoordinator: PolygonDetails {
    func presentPolygonDetails(_ cellData: CellData) {
        detailsTransition = DetailsTransition()
        let detailsViewController = DetailsViewController(cellData: cellData)
        detailsViewController.transitioningDelegate = detailsTransition
        listViewController?.present(detailsViewController, animated: true)
    }
}
