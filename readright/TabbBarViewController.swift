//
//  TabbBarViewController.swift
//  readright
//
//  Created by concarsadmin-mh on 27/11/2021.
//

import Foundation
import UIKit

class TabbBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor(red: 221.0/255.0, green: 134.0/255.0, blue: 89.0/255.0, alpha: 1)
        navigationItem.hidesBackButton = true
        let button:UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "Signout"), for: .normal)
        button.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 24, height: 20))
        button.addTarget(self, action: #selector(logOutUser), for: .touchUpInside)
        let label:UILabel = UILabel(frame: CGRect(x: -107, y: 0, width: 100, height: 20))
        label.font = UIFont(name: "Arial", size: 19)
        label.text = SharedPref.shared.userInfo?.name
        label.textColor = UIColor(red: 221.0/255.0, green: 134.0/255.0, blue: 89.0/255.0, alpha: 1)
        label.textAlignment = .right
        label.backgroundColor = UIColor.clear
        
        button.addSubview(label)
        
        let barButton:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = barButton
//        self.selectedIndex = SharedPref.shared.userInfo.lastVisitedTab;
    
        self.delegate = self
    }
    
    @objc private func logOutUser() {
        SharedPref.shared.removeUserInfo()
        if let destinationViewController = self.navigationController?.viewControllers.first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }
    
}
extension UIDevice {
    static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
}
