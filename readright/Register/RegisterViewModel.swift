//
//  RegisterViewModel.swift
//  readright
//
//  Created by concarsadmin-mh on 30/12/2021.
//

import Foundation
import RxSwift
import RxRelay

class RegisterViewModel {
    
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var loginResponse = BehaviorRelay<Bool>(value: false)
    
    func register(email: String, password: String, confirmPassword: String, name: String, gender: Int, yearOfBirth: String, hemianopiaType:Int, vpSide:Int?, vpCause:Int?, vpStartDate:String?, vpExtraCause:String?){
        self.isLoading.accept(true)
        provider.request(.Register(email: email, password: password, confirmPassword: confirmPassword, name: name, gender: gender, yearOfBirth: yearOfBirth, hemianopiaType: hemianopiaType, vpSide: vpSide, vpCause: vpCause, vpStartDate: vpStartDate, vpExtraCause: vpExtraCause))
            .map(NetworkModels.LoginResponse.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if response != nil {
                            SharedPref.shared.setToken(token: response.token)
                            self.getUserInfo()
                        }
                    case .error(let error):do {
                        self.isLoading.accept(false)
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func getUserInfo(){
        provider.request(.GetUserInfo)
            .map(NetworkModels.UserInfo.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if response != nil {
                            SharedPref.shared.setUserInfo(userInfo: response)
                            self.loginResponse.accept(true)
                        }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
}
