//
//  DetailsViewController.swift
//  Polygons
//
//  Created by Krzysztof Lech on 18/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    private enum Constants {
        static let padding: CGFloat = 20
    }
    
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var personView: PersonView!
    
    @IBOutlet private var personViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var personViewTrailingConstraint: NSLayoutConstraint!
    
    var data: CellData
    
    init(cellData: CellData) {
        data = cellData
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPersonView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPersonView() {
        personViewLeadingConstraint.constant = Constants.padding
        personViewTrailingConstraint.constant = Constants.padding
        personView.layoutIfNeeded()
        
        let size = UIScreen.main.bounds.width - Constants.padding * 2
        data.path = PolygonPath(sidesNumber: data.sides, size: size)

        personView.configure(withData: data)
    }
    
    @IBAction func backButtonAction() {
        dismiss(animated: true)
    }
}
