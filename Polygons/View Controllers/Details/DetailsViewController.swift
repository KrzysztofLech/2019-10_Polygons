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
        static let changeStyleAnimationDuration = 2.0
        static let onExitChangeStyleAnimationDuration = 0.5
    }
    
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var personView: PersonView!
    @IBOutlet private var backgroundView: AnimatedGradientView!
    
    @IBOutlet private var personViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var personViewTrailingConstraint: NSLayoutConstraint!
    
    private var data: CellData
    
    init(cellData: CellData) {
        data = cellData
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPersonView()
        createColorStyles()
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
        guard isStyleModified else {
            dismiss(animated: true)
            return
        }
        
        isDismising = true
        changeStyle()
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.onExitChangeStyleAnimationDuration) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    //MARK: - Change style methods -
    
    private enum MaskType {
        case start, end
    }
    
    private var snapshot: UIImage?
    private var snapshotImageView = UIImageView()
    private var colorStyles = ColorStyles()
    private var currentStyle = ColorStyle()
    private var isStyleModified = false
    private var isDismising = false
    private var isAnimating = false {
        didSet {
            buttonsView.isHidden = isAnimating
        }
    }
    
    @IBAction func changeStyleButtonAction() {
        changeStyle()
    }
    
    private func changeStyle() {
        isAnimating = true
        
        changeCurrentStyle()
        makeSnapshot()
        showSnapshot()
        setSelectedStyle()
        showMask()
    }
    
    private func createColorStyles() {
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
        personView.configure(withData: newStyleData)
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
        let startPath = getPath(forMaskType: .start)
        let endPath = getPath(forMaskType: .end)

        let maskLayer = CAShapeLayer()
        maskLayer.path = startPath
        snapshotImageView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = isDismising ? Constants.onExitChangeStyleAnimationDuration : Constants.changeStyleAnimationDuration
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = self
        
        maskLayer.add(animation, forKey: nil)
        maskLayer.path = endPath
    }
        
    private func getPath(forMaskType maskType: MaskType) -> CGPath {
        switch maskType {
        case .start: return WavePath(phase: .start).cgPath
        case .end: return WavePath(phase: .end).cgPath
        }
    }
}

extension DetailsViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        snapshotImageView.removeFromSuperview()
        isAnimating = false
    }
}

//MARK: - Color Style structs -

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
