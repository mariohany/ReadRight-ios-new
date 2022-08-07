//
//  TherapyViewModel.swift
//  readright
//
//  Created by concarsadmin-mh on 28/03/2022.
//

import Foundation
import RxSwift
import RxRelay


class TherapyViewModel {
    var therapy_duration:Int = 0
    var therapyItemTitle:String = ""
    var readingBookID:Int = 0
    var readingChapterID:Int = 0
    
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var therapyResult = BehaviorRelay<NetworkModels.SubmitTherapyResponse?>(value: nil)
    var status = BehaviorRelay<Int?>(value: nil)
    var bookResult = BehaviorRelay<[NetworkModels.Book]>(value: [])
    var chapterResult = BehaviorRelay<[NetworkModels.Chapter]>(value: [])
    
    func submitTherapyInterval(){
        self.isLoading.accept(true)
        provider.request(.GetSearchTestHistory)
            .map(NetworkModels.SubmitTherapyResponse.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        self.therapyResult.accept(response)
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    func requestBooks(){
        self.isLoading.accept(true)
        provider.request(.GetBooks)
            .map([NetworkModels.Book].self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        self.bookResult.accept(response)
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    func requestChapters(){
        self.isLoading.accept(true)
        provider.request(.GetChaptersByBook(bookId: readingBookID))
            .map([NetworkModels.Chapter].self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        self.chapterResult.accept(response)
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
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
                            self.status.accept(response.status ?? 1)
                        }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
}
