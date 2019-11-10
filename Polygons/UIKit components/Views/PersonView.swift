//
//  PersonView.swift
//  Polygons
//
//  Created by Krzysztof Lech on 19/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class PersonView: UIView {
        
    @IBOutlet private var bgView: GradientView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var personAvatarImageView: UIImageView!
    @IBOutlet private var personNameLabel: UILabel!
    @IBOutlet private var yContentPositionConstraint: NSLayoutConstraint!
    
    var borderColor = Colors.color1
    
    private var moveContent = false
    private var path = UIBezierPath()
    private var borderLayer = CAShapeLayer()
    private var borderWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        showContent()
    }
    
    func showContent() {
        moveContentIfNeeded()
        setupBackgroundColor()
        createPolygonalMask()
        addBorder()
    }
    
    private func setupView() {
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func moveContentIfNeeded() {
        let offset = bounds.height * 0.09
        yContentPositionConstraint.constant = moveContent ? offset : 0
        layoutIfNeeded()
    }
    
    func setupBackgroundColor() {
        bgView.setNeedsDisplay()
    }
        
    private func createPolygonalMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    func addBorder() {
        borderLayer.removeFromSuperlayer()
        
        borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.lineJoin = .round
        borderLayer.lineCap = .round
        
        layer.addSublayer(borderLayer)
    }
        
    func configure(withData data: CellData, borderWidth: CGFloat) {
        moveContent = data.moveContent
        bgView.middleColor = data.backgroundColor
        path = data.path
        personAvatarImageView.image = data.person.avatar
        personNameLabel.text = data.person.name
        self.borderWidth = borderWidth
    }
}
