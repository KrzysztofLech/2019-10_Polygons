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
    @IBOutlet private var personViewWidthConstraint: NSLayoutConstraint!
    
    private let styleController = DetailsStyleController()
    private var data: CellData
    private var personViewWidth: CGFloat {
        return min(screenWidth, screenHeight) - Constants.padding * 2
    }
    
    // MARK: - init methods
    
    init(cellData: CellData) {
        data = cellData
        super.init(nibName: nil, bundle: nil)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPersonView()
        setupStyleController()
        styleController.createColorStyles()
    }
    
    private func setupStyleController() {
        styleController.view = view
        styleController.personView = personView
        styleController.buttonsView = buttonsView
        styleController.backgroundView = backgroundView
        styleController.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPersonView() {
        personViewWidthConstraint.constant = personViewWidth
        personView.layoutIfNeeded()
        
        data.path = PolygonPath(sidesNumber: data.sides, size: Double(personViewWidth))
        personView.configure(withData: data, borderWidth: AppSettings.detailsPolygonBorderWidth)
    }
    
    // MARK: - Button methods
    
    @IBAction func backButtonAction() {
        guard styleController.isStyleModified else {
            dismiss(animated: true)
            return
        }
        
        styleController.changeStyleBeforeDismiss { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @IBAction func changeStyleButtonAction() {
        styleController.changeStyle()
    }
    
    // MARK: - Gesture recognizer method
    
    @IBAction func panGestureAction(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        let translation = sender.translation(in: view)
        if translation.y > 50 {
            styleController.changeStyle()
        } else if translation.y < -50 {
            // TODO: animation from bottom
        }
    }
}
