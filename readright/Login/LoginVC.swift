//
//  LoginVC.swift
//  readright
//
//  Created by concarsadmin-mh on 31/12/2021.
//

import UIKit
import RxGesture
import RxSwift
import JWTDecode

class LoginVC: UIViewController {
    
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    var initialViewController = UIViewController()
    @IBOutlet weak private var LoginEmailField:CustomTextField!
    @IBOutlet weak private var LoginPasswordField:CustomTextField!
    @IBOutlet weak private var forgetPasswordBtn:UILabel!
    @IBOutlet weak private var registerBtn:UILabel!
    private let viewModel = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgetPasswordBtn.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            let email: String = self?.LoginEmailField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard email.isEmpty, Validator.validate(email: email) else {
                Helpers.handleErrorMessages(message: "يجب ادخال بريد الكتروني صحيح!")
                return
            }
            self?.viewModel.forgetPassword(email: email)
        })
        
        registerBtn.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            DispatchQueue.main.async {
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
                self?.navigationController?.pushViewController(vc!, animated: true)
            }
        })
        
        observeLogin()
        observeLoading()
        observeError()
    }
    
    @IBAction func pressLoginBtn() {
        let email: String = self.LoginEmailField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password: String = self.LoginPasswordField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !email.isEmpty, Validator.validate(email: email) else {
            Helpers.handleErrorMessages(message: "يجب ادخال بريد الكتروني صحيح!")
            return
        }
        guard !password.isEmpty else {
            Helpers.handleErrorMessages(message: "يجب ادخال كلمة السر!")
            return
        }
        
        viewModel.login(email: email, password: password)
    }
    
    func observeLogin(){
        viewModel.loginResponse.subscribe { status in
            if let state = status.element, state == true{
                self.initialViewController = self.mainStoryBoard.instantiateViewController(withIdentifier: "TabbBarViewController")
                (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window?.rootViewController = self.initialViewController
            }
        }
    }
    
    func observeLoading() {
        viewModel.isLoading.asObservable().subscribe { status in
            if let state = status.element, state == true{
                self.view.showActivityView()
            }else {
                self.view.hideActivityView()
            }
        }
    }
    
    func observeError() {
        viewModel.error.asObservable().subscribe { status in
            if let error = status.element, error != "" {
                Helpers.handleErrorMessages(message: error)
            }
            print(status)
        }
    }
    
}
