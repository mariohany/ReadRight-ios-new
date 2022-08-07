//
//  CustomAlert.swift
//  readright
//
//  Created by user225703 on 7/13/22.
//

import Foundation
import UIKit

@objc protocol CustomAlertViewDelegate:AnyObject {
    func didSelectButtonAtIndex(tag:Int, index:Int)
}

class CustomAlertView: UIView {
    var viewMessage:UIImageView?
    var viewBackground:UIView?
    var parent:CustomAlertViewDelegate?
    var TAG:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public init?(title:String, message:String, messageFont:CGFloat, buttonTitle:String, delegate:CustomAlertViewDelegate, tag:Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        TAG = tag
        parent = delegate
        viewBackground = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        viewBackground?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        viewMessage = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_box_popup"))//300x270
        let lblTitle:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 70))
        lblTitle.text = title
        lblTitle.font = UIFont(name: "AdobeArabic-Regular", size: 35.0)
        lblTitle.textColor = UIColor(red:63/255.0, green:63/255.0, blue:63/255.0, alpha:1)
        lblTitle.textAlignment = .center
        let lblMessage:UILabel = UILabel(frame: CGRect(x: 10, y: 70, width: 280, height: 130))
        lblMessage.numberOfLines = 4
        lblMessage.text = message
        lblMessage.font = UIFont(name: "AdobeArabic-Regular", size: messageFont)
        lblMessage.textAlignment = .center
        lblMessage.textColor = UIColor(red:100/255.0, green:100/255.0, blue:100/255.0, alpha:1)
        
        let imageLine:UIImageView = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_line_box_popup"))
        imageLine.frame = CGRect(x: 0, y: 60, width: 300, height: 1)
        
        let imageLine2:UIImageView = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_line_box_popup"))
        imageLine2.frame = CGRect(x: 0, y: 205, width: 300, height: 1)
        let btnOk:UIButton = UIButton.init(frame: CGRect(x: 0, y: 205, width: 300, height: 70))
        btnOk.addTarget(self, action: #selector(btnOKClick), for: .touchUpInside)
        btnOk.setTitle(buttonTitle, for: .normal)
        btnOk.titleLabel?.font = UIFont(name:"AdobeArabic-Regular", size:30.0)
        btnOk.setTitleColor(UIColor(red:221.0/255.0, green:134.0/255.0, blue:89.0/255.0, alpha:1), for: .normal)
        viewMessage?.addSubview(lblTitle)
        viewMessage?.addSubview(lblMessage)
        viewMessage?.addSubview(imageLine)
        viewMessage?.addSubview(imageLine2)
        viewMessage?.addSubview(btnOk)
        viewMessage?.isUserInteractionEnabled = true
        viewBackground?.addSubview(viewMessage!)
        viewMessage?.center = viewBackground!.center
    }



    public init?(title:String, message:String, buttonTitle:String, delegate:CustomAlertViewDelegate, tag:Int){
        super.init(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        TAG = tag
        parent = delegate
        viewBackground = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        viewBackground?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        viewMessage = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_box_popup"))//300x270
        let lblTitle:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 70))
        lblTitle.text = title
        lblTitle.font = UIFont(name: "AdobeArabic-Regular", size: 35.0)
        lblTitle.textColor = UIColor(red:63/255.0, green:63/255.0, blue:63/255.0, alpha:1)
        lblTitle.textAlignment = .center
        let lblMessage:UILabel = UILabel(frame: CGRect(x: 10, y: 70, width: 280, height: 130))
        lblMessage.numberOfLines = 4
        lblMessage.text = message
        lblMessage.font = UIFont(name: "AdobeArabic-Regular", size: 33.0)
        lblMessage.textAlignment = .center
        lblMessage.textColor = UIColor(red:100/255.0, green:100/255.0, blue:100/255.0, alpha:1)
        
        let imageLine:UIImageView = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_line_box_popup"))
        imageLine.frame = CGRect(x: 0, y: 60, width: 300, height: 1)
        
        let imageLine2:UIImageView = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_line_box_popup"))
        imageLine2.frame = CGRect(x: 0, y: 205, width: 300, height: 1)
        let btnOk:UIButton = UIButton(frame: CGRect(x: 0, y: 205, width: 300, height: 70))
        btnOk.addTarget(self, action: #selector(btnOKClick), for: .touchUpInside)
        btnOk.setTitle(buttonTitle, for: .normal)
        btnOk.titleLabel?.font = UIFont(name:"AdobeArabic-Regular", size:30.0)
        btnOk.setTitleColor(UIColor(red:221.0/255.0, green:134.0/255.0, blue:89.0/255.0, alpha:1), for: .normal)
        viewMessage?.addSubview(lblTitle)
        viewMessage?.addSubview(lblMessage)
        viewMessage?.addSubview(imageLine)
        viewMessage?.addSubview(imageLine2)
        viewMessage?.addSubview(btnOk)
        viewMessage?.isUserInteractionEnabled = true
        viewBackground?.addSubview(viewMessage!)
        viewMessage?.center = viewBackground!.center
    }
    
    public init?(title:String, buttonOKTitle:String, buttonCancelTitle:String, delegate:CustomAlertViewDelegate, tag:Int){
        super.init(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        TAG = tag
        parent = delegate
        viewBackground = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        viewBackground?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        viewMessage = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_box_popup"))//300x270
        let lblTitle:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 128))
            lblTitle.text = title
            lblTitle.numberOfLines = 4
            lblTitle.font = UIFont(name: "AdobeArabic-Regular", size: 35.0)
        lblTitle.textAlignment = .center
        
        let imageLine1:UIImageView = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_line_box_popup"))
        imageLine1.frame = CGRect(x: 0, y: 128, width: 300, height: 1)
            
            
        let btnOk:UIButton = UIButton(frame: CGRect(x: 0, y: 129, width: 300, height: 70))
        btnOk.addTarget(self, action: #selector(btnOKClick), for: .touchUpInside)
        btnOk.setTitle(buttonOKTitle, for: .normal)
        btnOk.titleLabel?.font = UIFont(name:"AdobeArabic-Regular", size:30.0)
        btnOk.setTitleColor(UIColor(red:221.0/255.0, green:134.0/255.0, blue:89.0/255.0, alpha:1), for: .normal)

        let imageLine2:UIImageView = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_line_box_popup"))
        imageLine2.frame = CGRect(x: 0, y: 199, width: 300, height: 1)
            
        let btnCancel:UIButton = UIButton(frame:CGRect(x: 0, y: 200, width: 300, height: 70))
        btnCancel.addTarget(self, action:#selector(btnCancelClick), for: .touchUpInside)
        btnCancel.setTitle(buttonCancelTitle, for:.normal)
            btnCancel.titleLabel?.font = UIFont(name:"AdobeArabic-Regular", size:30.0)
            btnCancel.setTitleColor(UIColor(red:221.0/255.0, green:134.0/255.0, blue:89.0/255.0, alpha:1), for: .normal)

            
        viewMessage?.addSubview(lblTitle)
        viewMessage?.addSubview(imageLine1)
        viewMessage?.addSubview(imageLine2)
        viewMessage?.addSubview(btnOk)
        viewMessage?.addSubview(btnCancel)
        viewMessage?.isUserInteractionEnabled = true
        viewBackground?.addSubview(viewMessage!)
        viewMessage?.center = viewBackground!.center
    }

    public init?(title:String, messageImage:UIImage, buttonTitle:String, delegate:CustomAlertViewDelegate, tag:Int){
        super.init(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        TAG = tag
        parent = delegate
        viewBackground = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        viewBackground?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        viewMessage = UIImageView(image: UIImage(named: "therapy_therapy_take_tests_box_popup"))//300x270
        let lblTitle:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 70))
        lblTitle.text = title
        lblTitle.font = UIFont(name: "AdobeArabic-Regular", size: 35.0)
        lblTitle.textAlignment = .center

        let imgMessageHeight = messageImage.size.height > 165 ? messageImage.size.height / 2.2 : messageImage.size.height
        let imgMessageWidth = messageImage.size.height > 165 ? messageImage.size.width / 2.3 : messageImage.size.width
            
        let imgMessage:UIImageView = UIImageView(frame:CGRect(x: (300-imgMessageWidth)/2, y: (160-imgMessageHeight)/2 + 50, width: imgMessageWidth, height: imgMessageHeight))
        imgMessage.image = messageImage
        let imageLine:UIImageView = UIImageView(image:UIImage(named:"therapy_therapy_take_tests_line_box_popup"))
        imageLine.frame = CGRect(x: 0, y: 210, width: 300, height: 1)
        
        let btnOk:UIButton = UIButton(frame:CGRect(x: 0, y: 205, width: 300, height: 70))
        btnOk.addTarget(self, action: #selector(btnOKClick), for: .touchUpInside)
        btnOk.setTitle(buttonTitle, for: .normal)
        btnOk.titleLabel?.font = UIFont(name:"AdobeArabic-Regular", size:30.0)
        btnOk.setTitleColor(UIColor(red:221.0/255.0, green:134.0/255.0, blue:89.0/255.0, alpha:1), for: .normal)
        
        viewMessage?.addSubview(lblTitle)
        viewMessage?.addSubview(imgMessage)
        viewMessage?.addSubview(imageLine)
        viewMessage?.addSubview(btnOk)
        viewMessage?.isUserInteractionEnabled = true
        viewBackground?.addSubview(viewMessage!)
        viewMessage?.center = viewBackground!.center
    }
    
    
    @objc func btnOKClick(){
        viewMessage?.removeFromSuperview()
        viewMessage = nil
        viewBackground?.removeFromSuperview()
        viewBackground = nil
        if let parent = parent{
            parent.didSelectButtonAtIndex(tag: self.TAG, index: 0)
        }
        self.removeFromSuperview()
    }
    
    @objc func btnCancelClick(){
        viewMessage?.removeFromSuperview()
        viewMessage = nil
        viewBackground?.removeFromSuperview()
        viewBackground = nil
        if let parent = parent{
            parent.didSelectButtonAtIndex(tag: self.TAG, index: 1)
        }
        self.removeFromSuperview()
    }
    
    public func show() {
        self.addSubview(viewBackground!)
        self.setNeedsLayout()
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window?.addSubview(self)
    }
}
