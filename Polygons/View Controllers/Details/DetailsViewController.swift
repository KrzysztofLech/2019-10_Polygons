//
//  DetailsViewController.swift
//  Polygons
//
//  Created by Krzysztof Lech on 18/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var contentView: UIView!
    
    private let data: CellData
    
    init(cellData: CellData) {
        data = cellData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backButtonAction() {
        dismiss(animated: true)
    }
}
