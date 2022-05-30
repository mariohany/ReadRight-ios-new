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
//    var searchResult = BehaviorRelay<[NetworkModels.HistoryItem]?>(value: nil)
    
    func submitTherapyInterval(){
        self.isLoading.accept(true)
        provider.request(.GetSearchTestHistory)
            .map(NetworkModels.ResultsBaseModel.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                case .success(let response): break
//                        if let response = response.History {
//                            self.searchResult.accept(response)
//                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
    func requestBooks(){
        self.isLoading.accept(true)
        provider.request(.GetBooks)
            .map(NetworkModels.Book.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                case .success(let response): break
//                        if let response = response.History {
//                            self.searchResult.accept(response)
//                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
    func requestChapters(){
        self.isLoading.accept(true)
        provider.request(.GetChaptersByBook(bookId: readingBookID))
            .map(NetworkModels.Chapter.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                case .success(let response): break
//                        if let response = response.History {
//                            self.searchResult.accept(response)
//                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
}
