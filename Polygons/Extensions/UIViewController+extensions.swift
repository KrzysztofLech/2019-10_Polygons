//
//  UIViewController+extensions.swift
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func toString() -> String {
        return String(describing: self)
    }
    
    var isPortrait: Bool {
        return UIScreen.main.bounds.width < UIScreen.main.bounds.height
    }
}
