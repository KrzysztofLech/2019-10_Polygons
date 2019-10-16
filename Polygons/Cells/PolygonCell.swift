//
//  PolygonCell.swift
//  Polygons
//
//  Created by Krzysztof Lech on 15/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class PolygonCell: UICollectionViewCell {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var personAvatarImageView: UIImageView!
    @IBOutlet private var personNameLabel: UILabel!
    
    private var path = UIBezierPath()
    private let shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder()
        createPolygonalMask()
    }
    
    private func setupView() {
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.black.cgColor
    }
    
    private func addBorder() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Colors.color4.cgColor
        shapeLayer.lineWidth = 5
        layer.addSublayer(shapeLayer)
    }
    
    private func createPolygonalMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    func configure(withData data: CellData) {
        containerView.backgroundColor = data.backgroundColor
        path = data.path
        personAvatarImageView.image = data.person.avatar
        personNameLabel.text = data.person.name
    }
}
