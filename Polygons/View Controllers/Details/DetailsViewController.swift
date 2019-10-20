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
        dismiss(animated: true)
    }
    
    //MARK: - Change style methods -
    
    private enum MaskType {
        case start, end
    }
    
    private var snapshot: UIImage?
    private var snapshotImageView = UIImageView()
    private var colorStyles = DetailsStyles()
    
    @IBAction func changeStyleButtonAction() {
        createColorStyles()
        makeSnapshot()
        showSnapshot()
        changeColorStyle(colorStyles.modified)
        showMask()
    }
    
    private func createColorStyles() {
        colorStyles.initial.backgroundViewColor1 = backgroundView.colour1
        colorStyles.initial.backgroundViewColor2 = backgroundView.colour2
        colorStyles.initial.personViewBackgroundColor = data.backgroundColor
        colorStyles.initial.personViewBorderColor = personView.borderColor
    }
    
    private func changeColorStyle(_ style: ColorStyle) {
        backgroundView.colour1 = style.backgroundViewColor1
        backgroundView.colour2 = style.backgroundViewColor2
        backgroundView.refreshGradient()
        
        let newStyleData = CellData(path: data.path,
                                    person: data.person,
                                    backgroundColor: style.personViewBackgroundColor,
                                    moveContent: data.moveContent,
                                    sides: data.sides)
        personView.configure(withData: newStyleData)
        personView.setupBackgroundColor()
        
        personView.borderColor = style.personViewBorderColor
        personView.addBorder()
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
        animation.duration = 2.0
        animation.fromValue = startPath
        animation.toValue = endPath
        
        maskLayer.add(animation, forKey: nil)
        maskLayer.path = endPath
    }
        
    private func getPath(forMaskType maskType: MaskType) -> CGPath {
        switch maskType {
        case .start:
            return UIBezierPath(rect: view.bounds).cgPath

        case .end:
            let frame = view.bounds.inset(by: UIEdgeInsets(top: view.bounds.height,
                                                           left: 0, bottom: 0, right: 0))
            return UIBezierPath(rect: frame).cgPath
        }
    }
}



struct ColorStyle {
    var backgroundViewColor1 = UIColor.white
    var backgroundViewColor2 = UIColor.white
    var personViewBackgroundColor = UIColor.white
    var personViewBorderColor = UIColor.white
}

struct DetailsStyles {
    var initial = ColorStyle()
    let modified = ColorStyle(backgroundViewColor1: Colors.color4,
                              backgroundViewColor2: Colors.color2,
                              personViewBackgroundColor: Colors.color4,
                              personViewBorderColor: Colors.color5)
}
