//
//  ColorDialogueView.swift
//  readright
//
//  Created by concarsadmin-mh on 29/03/2022.
//

import Foundation
import UIKit

@IBDesignable public class ColorDialogueView: UIView {
    @IBOutlet weak var BackgroundCurrentColorView: UIView!
    @IBOutlet weak var TextCurrentColorView: UIView!
    @IBOutlet weak var TextPalletteView: UIView!
    @IBOutlet weak var BackgroundPalletteView: UIView!
    private var currentBackgroundColor:UIColor?
    private var currentTextColor:UIColor?
    var delegate: ColorDialogueDelegate?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update (txtColor:UIColor, backgroundColor:UIColor) {
        currentTextColor = txtColor
        currentBackgroundColor = backgroundColor
        BackgroundCurrentColorView.isHidden = false
        BackgroundCurrentColorView.backgroundColor = currentBackgroundColor
        handleWhiteView(currentDesiredView: BackgroundCurrentColorView)
        
        TextCurrentColorView.isHidden = false
        TextCurrentColorView.backgroundColor = currentTextColor
        handleWhiteView(currentDesiredView: TextCurrentColorView)
        
        TextPalletteView.isHidden = true
        BackgroundPalletteView.isHidden = true
    }
    
    @IBAction func backgroundSettingBtn(_ sender: UIButton) {
        BackgroundCurrentColorView.isHidden = true
        BackgroundPalletteView.isHidden = false
    }
    
    @IBAction func textSettingsBtn(_ sender: UIButton) {
        TextCurrentColorView.isHidden = true
        TextPalletteView.isHidden = false
    }
    
    @IBAction func chooseTextColor(_ sender: UIButton) {
        currentTextColor = sender.backgroundColor
        TextPalletteView.isHidden = true
        TextCurrentColorView.isHidden = false
        TextCurrentColorView.backgroundColor = currentTextColor
        handleWhiteView(currentDesiredView: TextCurrentColorView)
    }
    
    @IBAction func chooseBackgroundColor(_ sender: UIButton) {
        currentBackgroundColor = sender.backgroundColor
        BackgroundPalletteView.isHidden = true
        BackgroundCurrentColorView.isHidden = false
        BackgroundCurrentColorView.backgroundColor = currentBackgroundColor
        handleWhiteView(currentDesiredView: BackgroundCurrentColorView)
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        delegate?.didPressContinueBtn(txtColor: currentTextColor!, backgroundColor: currentBackgroundColor!)
    }
    
    func handleWhiteView(currentDesiredView:UIView) {
        let settingIcon = currentDesiredView.viewWithTag(2) as? UIButton
        
        if(currentDesiredView.backgroundColor?.isEqualToColor(color2: UIColor(ciColor: .white), withTolerance: 0.2) ?? false){
            currentDesiredView.layer.borderWidth = 1.0
            settingIcon?.isSelected = true
        }else{
            currentDesiredView.layer.borderWidth = 0.0
            settingIcon?.isSelected = false
        }
        
    }
}

public extension UIColor{

    func isEqualToColor(color2: UIColor, withTolerance tolerance: CGFloat) -> Bool {

        var r1 : CGFloat = 0
        var g1 : CGFloat = 0
        var b1 : CGFloat = 0
        var a1 : CGFloat = 0
        var r2 : CGFloat = 0
        var g2 : CGFloat = 0
        var b2 : CGFloat = 0
        var a2 : CGFloat = 0

        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return abs(r1 - r2) <= tolerance &&
            abs(g1 - g2) <= tolerance &&
            abs(b1 - b2) <= tolerance &&
            abs(a1 - a2) <= tolerance
    }

}

protocol ColorDialogueDelegate {
    func didPressContinueBtn(txtColor:UIColor, backgroundColor:UIColor)
}
