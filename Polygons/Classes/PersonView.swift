//
//  PersonView.swift
//  Polygons
//
//  Created by Krzysztof Lech on 19/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class PersonView: UIView {
    
    enum Constants {
        static let borderWidth: CGFloat = 8
    }
    
    @IBOutlet private var bgView: GradientView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var personAvatarImageView: UIImageView!
    @IBOutlet private var personNameLabel: UILabel!
    @IBOutlet private var yContentPositionConstraint: NSLayoutConstraint!
    
    private var moveContent = false
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
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor.black.cgColor
    }
    
    private func moveContentIfNeeded() {
        let offset = bounds.height * 0.09
        yContentPositionConstraint.constant = moveContent ? offset : 0
        layoutIfNeeded()
    }
    
    private func setupBackgroundColor() {
        bgView.setNeedsDisplay()
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
        borderLayer.strokeColor = Colors.color1.cgColor
        borderLayer.lineWidth = Constants.borderWidth
        borderLayer.lineJoin = .round
        borderLayer.lineCap = .round
        
        layer.addSublayer(borderLayer)
    }
        
    func configure(withData data: CellData) {
        moveContent = data.moveContent
        bgView.middleColor = data.backgroundColor
        path = data.path
        personAvatarImageView.image = data.person.avatar
        personNameLabel.text = data.person.name
    }
}
