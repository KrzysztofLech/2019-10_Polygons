//
//  UITableView+extensions.swift
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(cellAndNibName name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }    
}
