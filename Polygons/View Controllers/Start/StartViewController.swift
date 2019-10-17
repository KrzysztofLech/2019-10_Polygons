//
//  StartViewController.swift
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController {
    
    @IBOutlet private var backgroundView: AnimatedGradientView!
    @IBOutlet private var personsNumberLabel: UILabel!
    @IBOutlet private var addButtons: [AddPersonButton]!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.startAnimation()
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
        let listViewController = ListViewController(personNumber: personNumber)
        listViewController.modalPresentationStyle = .fullScreen
        listViewController.modalTransitionStyle = .crossDissolve
        present(listViewController, animated: true)
    }
}
