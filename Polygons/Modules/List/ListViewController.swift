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
    @IBOutlet var toolBarView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    private var portraitMode = true
    private let personNumber: Int
    private let viewModel: ListViewModel
    private var cellSize: CGSize {
        var value: CGFloat = 0
        if isPortrait {
            value = screenWidth - Constants.outerPadding * 2
        } else {
            value = screenHeight - toolBarView.frame.height * 2
        }
        return  CGSize(width: value, height: value)
    }
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - init methods
    
    init(personNumber: Int) {
        self.personNumber = personNumber
        self.viewModel = ListViewModel(personsQuantity: personNumber)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.cellWidth = Double(cellSize.width)
        portraitMode = isPortrait
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard portraitMode != isPortrait else { return }
        setLayoutForNewOrientation()
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
    
    private func setLayoutForNewOrientation() {
        changeCollectionViewLayout()
        portraitMode = isPortrait
        viewModel.cellWidth = Double(cellSize.width)
        collectionView.reloadData()
    }
    
    // MARK: - Navigation methods
    
    @IBAction private func backButtonAction() {
        dismiss(animated: true)
    }
    
    private func navigateToDetailsController(dataIndex: Int) {
        guard let cellData = viewModel.getCellData(forIndex: dataIndex) else { return }
        coordinator?.presentPolygonDetails(cellData)
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

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.tapAnimation { [weak self] in
            self?.navigateToDetailsController(dataIndex: indexPath.item)
        }
    }
}
