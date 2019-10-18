//
//  UIView+extensions.swift
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

extension UIView {
    
    static func toString() -> String {
        return String(describing: self)
    }
    
    func fill(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}
