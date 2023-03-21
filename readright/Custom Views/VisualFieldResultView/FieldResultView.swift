//
//  FieldResultView.swift
//  readright
//
//  Created by concarsadmin-mh on 12/03/2022.
//

import Foundation
import UIKit

class FieldResultView: UIView {
    
    @IBOutlet weak var dot1_1: CustomView!
    @IBOutlet weak var dot1_2: CustomView!
    @IBOutlet weak var dot1_3: CustomView!
    @IBOutlet weak var dot1_4: CustomView!

    @IBOutlet weak var dot2_1: CustomView!
    @IBOutlet weak var dot2_2: CustomView!
    @IBOutlet weak var dot2_3: CustomView!
    @IBOutlet weak var dot2_4: CustomView!

    @IBOutlet weak var dot3_1: CustomView!
    @IBOutlet weak var dot3_2: CustomView!
    @IBOutlet weak var dot3_3: CustomView!
    @IBOutlet weak var dot3_4: CustomView!

    @IBOutlet weak var dot4_1: CustomView!
    @IBOutlet weak var dot4_2: CustomView!
    @IBOutlet weak var dot4_3: CustomView!
    @IBOutlet weak var dot4_4: CustomView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func renderResultViewWithAllScenarios(results:[Int]) {
        for circle in 1...Constants.NUMBER_OF_CIRCLES {
            for mode in 0..<Constants.NUMBER_OF_DOTES_IN_CIRCLE {
                let visibleDotCount:Int = results[(circle-1) * 9 + (0)] + results[(circle-1) * 9 + (mode + 5)] + results[(circle-1) * 9 + (mode/2+1)]
                + results[(circle-1) * 9 + (mode % 2 + 3)] - 4; //-16 because the two values
                let successRatio:Float = Float(visibleDotCount) / Float(Constants.NUMBER_OF_DOTES_IN_CIRCLE)
                let dotView:UIView = value(forKey: String(format: "dot%d_%d", circle,mode+1)) as! UIView
                
                if (successRatio == 1) {//visible dot
                    dotView.alpha = 1
                    dotView.backgroundColor = UIColor(ciColor: .white)
                    dotView.layer.borderWidth = 4
                    dotView.layer.borderColor = CGColor(red:119.0/255.0, green:156.0/255.0, blue:89.0/255.0, alpha:1)
                    dotView.layer.cornerRadius = 13
                } else if (successRatio < 1) {//blind or partilly dot
                    dotView.alpha = CGFloat(1 - successRatio)
                    dotView.backgroundColor = UIColor(ciColor: .black)
                    dotView.layer.borderColor = UIColor(ciColor: .black).cgColor
                    dotView.layer.borderWidth = 1
                    dotView.layer.cornerRadius = 13
                }
            }
        }
    }
    
    public func renderResultViewWithAlldots(results:[Int]) {
        for i in 0..<results.count{//Constants.NUMBER_OF_VISIUAL_FIELD_DOTS {
            let successRatio:Float = Float(results[i]) / Float(Constants.NUMBER_OF_DOTES_IN_CIRCLE)
            let dotView = self.value(forKeyPath: String(format: "dot%d_%d", (i/4 + 1),(i % 4 + 1))) as? UIView
            
            if (successRatio == 1) {//visible dot
                dotView?.alpha = 1
                dotView?.backgroundColor = UIColor(ciColor: .white)
                dotView?.layer.borderWidth = 4
                dotView?.layer.borderColor = CGColor(red:119.0/255.0, green:156.0/255.0, blue:89.0/255.0, alpha:1)
                dotView?.layer.cornerRadius = 13
            } else if (successRatio < 1) {//blind or partilly dot
                dotView?.alpha = 1
                dotView?.backgroundColor = UIColor(white: CGFloat(successRatio), alpha: 1)
                dotView?.layer.borderColor = UIColor(ciColor: .black).cgColor
                dotView?.layer.borderWidth = 1
                dotView?.layer.cornerRadius = 13
            }
        }
    }
    
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
