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
    
    func tapAnimation(completion: @escaping ()->()) {
        let initialTransformationValue = self.transform.a
        let isIdentity = self.transform.isIdentity

        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubicPaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                let transformationValue = initialTransformationValue * 1.2
                self.transform = CGAffineTransform(scaleX: transformationValue, y: transformationValue)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1) {
                if isIdentity {
                    self.transform = CGAffineTransform.identity
                } else {
                    self.transform = CGAffineTransform(scaleX: initialTransformationValue, y: initialTransformationValue)
                }
             }

         }) { _ in completion() }
    }
}
