//
//  HorizontalFlowLayout.swift
//  Polygons
//
//  Created by Krzysztof Lech on 04/11/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class HorizontalFlowLayout: UICollectionViewFlowLayout {
    
    private let cellSize: CGSize
    private let defaultItemScale: CGFloat = 0.7
    
    // MARK: - Init -
    
    init(cellSize: CGSize) {
        self.cellSize = cellSize
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare -
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        itemSize = cellSize
        
        let horizontalMargin = (collectionView!.frame.width - cellSize.width)/2
        let verticalMargin =  (collectionView!.frame.height - cellSize.height)/2
        sectionInset = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        minimumLineSpacing = 10
    }

    
    // MARK: - Attributes methods -
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        for itemAttributes in attributes! {
            changeLayoutAttributes(itemAttributes)
        }
        return attributes
    }
    
    private func changeLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) {
        let offset = collectionView!.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        
        let collectionCenter = collectionView!.frame.size.width / 2
        
        let maxDistance = itemSize.width + minimumLineSpacing
        let actualDistance = abs(collectionCenter - normalizedCenter) // odległość od środka collectionView
        let scaleDistance = min(actualDistance, maxDistance)
        
        let ratio = (maxDistance - scaleDistance) / maxDistance
        let scale = defaultItemScale + ratio * (1 - defaultItemScale)
        
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    

    // MARK: - Snap to center methods -
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        let midX: CGFloat = collectionView.bounds.size.width / 2
        
        guard let closestAttribute = findClosestAttributes(toXPosition: proposedContentOffset.x + midX) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let computedPoint = CGPoint(x: closestAttribute.center.x - midX, y: proposedContentOffset.y)
        return computedPoint
    }
    
    
    private func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        
        let searchRect = CGRect(
            x: xPosition - collectionView.bounds.width, y: collectionView.bounds.minY,
            width: collectionView.bounds.width * 2, height: collectionView.bounds.height
        )
        return layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) })
    }
}
