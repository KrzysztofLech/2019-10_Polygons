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
        static let outerPadding: CGFloat = UIScreen.main.bounds.width * 0.1
    }
    
    @IBOutlet var topView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    private var portraitMode = true
    private let personNumber: Int
    private let cellSize: CGSize
    private let viewModel: ListViewModel
    private let detailsTransition = DetailsTransition()
    
    
    // MARK: - init methods
    
    init(personNumber: Int) {
        self.personNumber = personNumber
        
        let cellWidth = UIScreen.main.bounds.width - Constants.outerPadding * 2
        cellSize = CGSize(width: cellWidth, height: cellWidth)
        self.viewModel = ListViewModel(personsQuantity: personNumber, cellWidth: Double(cellWidth))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portraitMode = isPortrait
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard portraitMode != isPortrait else { return }
        changeCollectionViewLayout()
        portraitMode = isPortrait
    }
        
    // MARK: - Setup methods
    
    private func setupCollectionView() {
        collectionView.register(cellAndNibName: PersonCell.toString())
        changeCollectionViewLayout()
    }
    
    private func changeCollectionViewLayout() {
        
        
        let horizontalLayout = HorizontalFlowLayout(cellSize: cellSize)
        let verticalLayout = VerticalFlowLayout(cellSize: cellSize)
        collectionView.collectionViewLayout = isPortrait ? verticalLayout : horizontalLayout
    }
    
    // MARK: - Other
    
    @IBAction private func backButtonAction() {
        dismiss(animated: true)
    }
    
    private func animateCell(_ cell: UICollectionViewCell?, completion: @escaping ()->()) {
        let initialTransformationValue = cell?.transform.a ?? 0
        let isIdentity = cell?.transform.isIdentity ?? false

        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubicPaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                let transformationValue = initialTransformationValue * 1.2
                cell?.transform = CGAffineTransform(scaleX: transformationValue, y: transformationValue)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1) {
                if isIdentity {
                    cell?.transform = CGAffineTransform.identity
                } else {
                    cell?.transform = CGAffineTransform(scaleX: initialTransformationValue, y: initialTransformationValue)
                }
             }

         }) { _ in completion() }
    }
    
    private func navigateToDetailsController(dataIndex: Int) {
        guard let cellData = viewModel.getCellData(forIndex: dataIndex) else { return }
        let detailsViewController = DetailsViewController(cellData: cellData)
        detailsViewController.transitioningDelegate = detailsTransition
        present(detailsViewController, animated: true)
    }
}

// MARK: - Collection View methods

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.toString(), for: indexPath) as? PersonCell,
            let cellData = viewModel.getCellData(forIndex: indexPath.item)
            else { return UICollectionViewCell() }
        
        cell.configure(withData: cellData)
        return cell
    }
}

//extension ListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return cellSize
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: Constants.outerPadding,
//                            left: Constants.outerPadding,
//                            bottom: Constants.outerPadding,
//                            right: Constants.outerPadding)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return Constants.outerPadding
//    }
//}
//
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        animateCell(cell) { [weak self] in
            self?.navigateToDetailsController(dataIndex: indexPath.item)
        }
    }
}
