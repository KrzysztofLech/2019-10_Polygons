//
//  ListViewController.swift
//  Polygons
//
//  Created by Krzysztof Lech on 14/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    private enum Constants {
        static let outerPadding: CGFloat = UIScreen.main.bounds.width * 0.25
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    private let personNumber: Int
    
    // MARK: - init methods
    
    init(personNumber: Int) {
        self.personNumber = personNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    // MARK: - Setup methods
    
    private func setupCollectionView() {
        collectionView.register(cellAndNibName: PolygonCell.toString())
    }
    
    // MARK: - Other
    
    @IBAction private func backButtonAction() {
        dismiss(animated: true)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PolygonCell.toString(), for: indexPath) as? PolygonCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = view.bounds.size.width - Constants.outerPadding * 2
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.outerPadding,
                            left: Constants.outerPadding,
                            bottom: Constants.outerPadding,
                            right: Constants.outerPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.outerPadding
    }
}
