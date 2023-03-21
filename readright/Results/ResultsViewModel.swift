//
//  ResultsViewModel.swift
//  readright
//
//  Created by concarsadmin-mh on 26/02/2022.
//

import Foundation
import RxSwift
import RxRelay

class ResultsViewModel {
    
    var therapyFrom:Int = 0
    var therapyTo:Int = 0
    var visualFrom:Int = 0
    var visualTo:Int = 0
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var searchResult = BehaviorRelay<[NetworkModels.SearchTestHistory]?>(value: nil)
    var readingResult = BehaviorRelay<[NetworkModels.ReadingResults]?>(value: nil)
    var neglectResult = BehaviorRelay<[NetworkModels.NeglectResultItem]?>(value: nil)
    var therapyResult = BehaviorRelay<NetworkModels.ResultsBaseModel?>(value: nil)
    var visualResult = BehaviorRelay<[NetworkModels.HistoryItem]?>(value: nil)
    
    func getSearchTaskHistory(){
        self.isLoading.accept(true)
        provider.request(.GetSearchTestHistory)
            .map([NetworkModels.SearchTestHistory].self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        self.searchResult.accept(response)
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    func getReadingHistory(){
        self.isLoading.accept(true)
        provider.request(.GetReadingTestHistory)
            .map([NetworkModels.ReadingResults].self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        self.readingResult.accept(response)
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    func getNeglectFieldHistory(){
        self.isLoading.accept(true)
        provider.request(.GetNeglectTestHistory)
            .map([NetworkModels.NeglectResultItem]?.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if let response = response {
                            self.neglectResult.accept(response)
                        }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    func getTherapyHistory(){
        self.isLoading.accept(true)
        provider.request(.GetTherapyHistory(from: therapyFrom, to: therapyTo))
            .map(NetworkModels.ResultsBaseModel.self)
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
    
    func getVisualFieldHistory(){
        self.isLoading.accept(true)
        provider.request(.GetFieldTestHistory(from: visualFrom, to: visualTo))
            .map([NetworkModels.HistoryItem].self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        self.visualResult.accept(response)
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }

    
}
