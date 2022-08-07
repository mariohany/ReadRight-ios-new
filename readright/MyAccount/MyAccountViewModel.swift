//
//  MyAccountViewModel.swift
//  readright
//
//  Created by concarsadmin-mh on 16/01/2022.
//

import Foundation
import RxSwift
import RxRelay

class MyAccountViewModel {
    
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var userInfo = BehaviorRelay<NetworkModels.UserInfo?>(value: nil)
    
    func getUserInfo(){
        self.isLoading.accept(true)
        provider.request(.GetUserInfo)
            .map(NetworkModels.UserInfo.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if response != nil {
                            SharedPref.shared.setUserInfo(userInfo: response)
                            self.userInfo.accept(response)
                        }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    func updateUserInfo(email: String, password: String, confirmPassword: String, name: String, gender: Int, yearOfBirth: String, hemianopiaType:Int, vpSide:Int?, vpCause:Int?, vpStartDate:String?, vpExtraCause:String?){
        self.isLoading.accept(true)
        provider.request(.UpdateUserInfo(email: email, password: password, confirmPassword: confirmPassword, name: name, gender: gender, yearOfBirth: yearOfBirth, hemianopiaType: hemianopiaType, vpSide: vpSide, vpCause: vpCause, vpStartDate: vpStartDate, vpExtraCause: vpExtraCause))
            .map(NetworkModels.UserInfo.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if response != nil {
                            SharedPref.shared.setUserInfo(userInfo: response)
                            self.userInfo.accept(response)
                        }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
}
