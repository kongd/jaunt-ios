//
//  MaterialCard.swift
//  MaterialCard
//
//  Created by Nathan Walker on 3/20/16.
//  Copyright © 2016 NathanWalker. All rights reserved.
//

import UIKit

public class MaterialCard: UIView {
    
    public var cornerRadius: CGFloat = 2
    
    public var shadowOffsetWidth = 0.0
    public var shadowOffsetHeight = 0.0
    public var shadowColor: UIColor? = UIColor.blackColor()
    public var shadowOpacity: Float = 0.1
    
    override public func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.CGPath
        
        layer.backgroundColor = cardGray.CGColor
    }
    
}
