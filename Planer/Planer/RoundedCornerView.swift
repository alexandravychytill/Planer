//
//  RoundedCornerView.swift
//  Planer
//
//  Created by Alexandra Vychytil on 07.01.22.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {
    
    // change the corner radius of the UIView (Alert)
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
}

