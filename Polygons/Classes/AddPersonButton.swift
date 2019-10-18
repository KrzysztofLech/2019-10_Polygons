//
//  AddPersonButton.swift
//  Polygons
//
//  Created by Krzysztof Lech on 14/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

@IBDesignable
final class AddPersonButton: RippleButton {
        
    @IBInspectable var value: Int = 0 {
        didSet {
            setTitle("+\(value)", for: .normal)
        }
    }
}
