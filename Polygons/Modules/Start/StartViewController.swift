//
//  StartViewController.swift
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController {
    
    @IBOutlet private var backgroundView: AnimatedGradientView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var personsNumberLabel: UILabel!
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundView.startAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        stackView.axis = isPortrait ? .vertical : .horizontal
    }
    
    private var personNumber = 20 {
        didSet {
            personsNumberLabel.text = String(personNumber)
        }
    }
    
    @IBAction private func addButtonAction(_ sender: AddPersonButton) {
        personNumber += sender.value
    }
    
    @IBAction func clearButtonAction() {
        personNumber = 1
    }
    
    @IBAction func okButtonAction() {
        coordinator?.presentPolygonList(personNumber)
    }
}
