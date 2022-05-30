//
//  LoginViewModel.swift
//  readright
//
//  Created by concarsadmin-mh on 31/12/2021.
//

import Foundation
import RxSwift
import RxRelay


class LoginViewModel {
    
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var loginResponse = BehaviorRelay<Bool>(value: false)
    
    func login(email: String, password: String){
        self.isLoading.accept(true)
        provider.request(.Login(email: email, password: password))
            .map(NetworkModels.LoginResponse.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if response != nil {
                            SharedPref.shared.setToken(token: response.token)
                            self.loginResponse.accept(true)
                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
    func forgetPassword(email: String){
        self.isLoading.accept(true)
        provider.request(.ForgetPassword(email: email))
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if response != nil {
                            
                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
}
