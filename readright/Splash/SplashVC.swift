//
//  SplashVC.swift
//  readright
//
//  Created by concarsadmin-mh on 12/01/2022.
//

import Foundation
import UIKit

class SplashVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let authStoryBoard = UIStoryboard(name: "Auth", bundle: nil)
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    var initialViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = SharedPref.shared.accessToken , !token.isEmpty{
            initialViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabbBarViewController")
            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window?.rootViewController = initialViewController
        }else{
            initialViewController = authStoryBoard.instantiateViewController(withIdentifier: "AuthNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window?.rootViewController = initialViewController
        }
    }
}
