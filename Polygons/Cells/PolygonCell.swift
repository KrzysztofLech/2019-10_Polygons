//
//  PolygonCell.swift
//  Polygons
//
//  Created by Krzysztof Lech on 15/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class PolygonCell: UICollectionViewCell {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var personAvatarImageView: UIImageView!
    @IBOutlet private var personNameLabel: UILabel!
    @IBOutlet private var yContentPositionConstraint: NSLayoutConstraint!
    
    private var moveContent = false
    private var bgColor: UIColor?
    private var path = UIBezierPath()
    private var borderLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        moveContentIfNeeded()
        setupBackgroundColor()
        createPolygonalMask()
        addBorder()
    }
    
    private func setupView() {
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.black.cgColor
    }
    
    private func moveContentIfNeeded() {
        let offset = bounds.height * 0.09
        yContentPositionConstraint.constant = moveContent ? offset : 0
        layoutIfNeeded()
    }
    
    private func setupBackgroundColor() {
        containerView.backgroundColor = bgColor
    }
        
    private func createPolygonalMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    private func addBorder() {
        borderLayer.removeFromSuperlayer()
        
        borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = Colors.color4.cgColor
        borderLayer.lineWidth = 5
        borderLayer.lineJoin = .round
        borderLayer.lineCap = .round
        
        layer.addSublayer(borderLayer)
    }
        
    func configure(withData data: CellData) {
        moveContent = data.moveContent
        bgColor = data.backgroundColor
        path = data.path
        personAvatarImageView.image = data.person.avatar
        personNameLabel.text = data.person.name
    }
}
