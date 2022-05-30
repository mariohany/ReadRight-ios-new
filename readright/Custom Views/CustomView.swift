//
//  CustomView.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import UIKit


@IBDesignable public class CustomView: UIView {

    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
        }
    }
    
}
