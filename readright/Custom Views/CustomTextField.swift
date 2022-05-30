//
//  CustomTextField.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import UIKit

@IBDesignable public class CustomTextField: UITextField {
    
    
    @IBInspectable var isRightAlign: Bool = false {
        didSet {
            if(isRightAlign)
            {
                self.textAlignment = .right
            }
        }
    }
    
    @IBInspectable var rTxtMargin : CGFloat = 0.0
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x -= rTxtMargin
        return newBounds
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x -= rTxtMargin
        return newBounds
    }
}

