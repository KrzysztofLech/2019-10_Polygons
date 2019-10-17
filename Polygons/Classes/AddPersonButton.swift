//
//  AddPersonButton.swift
//  Polygons
//
//  Created by Krzysztof Lech on 14/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

@IBDesignable
final class AddPersonButton: UIButton {
        
    @IBInspectable var value: Int = 0 {
        didSet {
            setTitle("+\(value)", for: .normal)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
