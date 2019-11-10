//
//  UIViewController+extensions.swift
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func toString() -> String {
        return String(describing: self)
    }
        
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var isPortrait: Bool {
        return screenWidth < screenHeight
    }
}
