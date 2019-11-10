//
//  VerticalFlowLayout.swift
//  Polygons
//
//  Created by Krzysztof Lech on 04/11/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class VerticalFlowLayout: UICollectionViewFlowLayout {
    
    private let cellSize: CGSize
    
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
        
        scrollDirection = .vertical
        itemSize = cellSize
        
        let verticalMargin =  (collectionView!.frame.height - cellSize.height)/2
        sectionInset = UIEdgeInsets(top: verticalMargin, left: 0, bottom: verticalMargin, right: 0)
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
        let offset = collectionView!.contentOffset.y
        let normalizedCenter = attributes.center.y - offset
        
        let collectionCenter = collectionView!.frame.size.height / 2
        
        let maxDistance = itemSize.height + minimumLineSpacing
        let actualDistance = abs(collectionCenter - normalizedCenter) // odległość od środka collectionView
        let scaleDistance = min(actualDistance, maxDistance)
        
        let ratio = (maxDistance - scaleDistance) / maxDistance
        let scale = AppSettings.smallItemScale + ratio * (1 - AppSettings.smallItemScale)
        
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
        
        let midY: CGFloat = collectionView.bounds.size.height / 2
        
        guard let closestAttribute = findClosestAttributes(toYPosition: proposedContentOffset.y + midY) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let computedPoint = CGPoint(x: proposedContentOffset.x, y: closestAttribute.center.y - midY)
        return computedPoint
    }
    
    
    private func findClosestAttributes(toYPosition yPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        
        let searchRect = CGRect(
            x: collectionView.bounds.minX, y: yPosition - collectionView.bounds.height,
            width: collectionView.bounds.width, height: collectionView.bounds.height * 2
        )
        return layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.y - yPosition) < abs($1.center.y - yPosition) })
    }
}
