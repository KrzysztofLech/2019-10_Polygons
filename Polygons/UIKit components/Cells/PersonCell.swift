//
//  PersonCell.swift
//  Polygons
//
//  Created by Krzysztof Lech on 15/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class PersonCell: UICollectionViewCell {
    
    private enum Constants {
        static let borderWidth: CGFloat = 6
    }
    
    @IBOutlet private var personView: PersonView!
        
    func configure(withData data: CellData) {
        personView.configure(withData: data, borderWidth: Constants.borderWidth)
        personView.showContent()
    }
}
