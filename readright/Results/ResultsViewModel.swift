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
    var searchResult = BehaviorRelay<[NetworkModels.HistoryItem]?>(value: nil)
    var readingResult = BehaviorRelay<[NetworkModels.HistoryItem]?>(value: nil)
    var neglectResult = BehaviorRelay<[NetworkModels.HistoryItem]?>(value: nil)
    var therapyResult = BehaviorRelay<NetworkModels.ResultsBaseModel?>(value: nil)
    var visualResult = BehaviorRelay<[NetworkModels.HistoryItem]?>(value: nil)
    
    func getSearchTaskHistory(){
        self.isLoading.accept(true)
        provider.request(.GetSearchTestHistory)
            .map(NetworkModels.ResultsBaseModel.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if let response = response.History {
                            self.searchResult.accept(response)
                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
    func getReadingHistory(){
        self.isLoading.accept(true)
        provider.request(.GetReadingTestHistory)
            .map(NetworkModels.ResultsBaseModel.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if let response = response.History {
                            self.readingResult.accept(response)
                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
    func getNeglectFieldHistory(){
        self.isLoading.accept(true)
        provider.request(.GetNeglectTestHistory)
            .map(NetworkModels.ResultsBaseModel.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if let response = response.History {
                            self.neglectResult.accept(response)
                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
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
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
    func getVisualFieldHistory(){
        self.isLoading.accept(true)
        provider.request(.GetFieldTestHistory(from: visualFrom, to: visualTo))
            .map(NetworkModels.ResultsBaseModel.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if let response = response.History {
                            self.visualResult.accept(response)
                        }
                    case .error(let error):
                        self.error.accept(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }

    
}
