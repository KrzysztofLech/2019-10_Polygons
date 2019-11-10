//
//  DetailsStyleController.swift
//  Polygons
//
//  Created by Krzysztof Lech on 10/11/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class DetailsStyleController: NSObject {
        
    private enum Constants {
        static let changeStyleAnimationDuration = 2.0
        static let onExitChangeStyleAnimationDuration = 0.5
    }
    
    private enum MaskType {
        case start, end
    }
    
    private var snapshot: UIImage?
    private var snapshotImageView = UIImageView()
    private var colorStyles = ColorStyles()
    private var currentStyle = ColorStyle()
    private var isAnimating = false {
        didSet {
            buttonsView.isHidden = isAnimating
        }
    }
    private var animationDuration: Double {
        return isDismissing ? Constants.onExitChangeStyleAnimationDuration : Constants.changeStyleAnimationDuration
    }

    var isStyleModified = false
    var isDismissing = false
    
    var view: UIView!
    var personView: PersonView!
    var buttonsView: UIView!
    var backgroundView: AnimatedGradientView!
    var data: CellData!
    
    func changeStyle() {
        isAnimating = true
        
        changeCurrentStyle()
        makeSnapshot()
        showSnapshot()
        setSelectedStyle()
        showMask()
    }
    
    func createColorStyles() {
        colorStyles.initial = ColorStyle(backgroundViewColor1: backgroundView.colour1,
                                         backgroundViewColor2: backgroundView.colour2,
                                         personViewBackgroundColor: data.backgroundColor,
                                         personViewBorderColor: personView.borderColor)
        
        colorStyles.modified = ColorStyle(backgroundViewColor1: Colors.color4,
                                          backgroundViewColor2: Colors.color2,
                                          personViewBackgroundColor: Colors.color4,
                                          personViewBorderColor: Colors.color5)
    }
    
    private func setSelectedStyle() {
        backgroundView.colour1 = currentStyle.backgroundViewColor1
        backgroundView.colour2 = currentStyle.backgroundViewColor2
        backgroundView.refreshGradient()
        
        let newStyleData = CellData(path: data.path,
                                    person: data.person,
                                    backgroundColor: currentStyle.personViewBackgroundColor,
                                    moveContent: data.moveContent,
                                    sides: data.sides)
        personView.configure(withData: newStyleData, borderWidth: AppSettings.detailsPolygonBorderWidth)
        personView.setupBackgroundColor()
        
        personView.borderColor = currentStyle.personViewBorderColor
        personView.addBorder()
    }
    
    private func changeCurrentStyle() {
        currentStyle = isStyleModified ? colorStyles.initial : colorStyles.modified
        isStyleModified.toggle()
    }
    
    private func makeSnapshot() {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        snapshot = renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    private func showSnapshot() {
        guard let snapshot = snapshot else { return }

        snapshotImageView = UIImageView(frame: view.frame)
        snapshotImageView.image = snapshot
        view.addSubview(snapshotImageView)
    }

    private func showMask() {
        let startPath = WavePath(phase: .start).cgPath
        let endPath = WavePath(phase: .end).cgPath

        let maskLayer = CAShapeLayer()
        maskLayer.path = startPath
        snapshotImageView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = animationDuration
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = self
        
        maskLayer.add(animation, forKey: nil)
        maskLayer.path = endPath
    }
    
    func changeStyleBeforeDismiss(completion: @escaping ()->()) {
        isDismissing = true
        changeStyle()
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.onExitChangeStyleAnimationDuration) {
            completion()
        }
    }
}

extension DetailsStyleController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        snapshotImageView.removeFromSuperview()
        isAnimating = false
    }
}

//MARK: - Color Style structs

struct ColorStyle {
    var backgroundViewColor1 = UIColor.white
    var backgroundViewColor2 = UIColor.white
    var personViewBackgroundColor = UIColor.white
    var personViewBorderColor = UIColor.white
}

struct ColorStyles {
    var initial = ColorStyle()
    var modified = ColorStyle()
}
