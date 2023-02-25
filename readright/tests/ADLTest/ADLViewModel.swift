//
//  ADLViewModel.swift
//  readright
//
//  Created by user225703 on 7/14/22.
//

import Foundation
import RxSwift
import RxRelay

class ADLViewModel {
    var adl_FindingThings:Int = 0
    var adl_driving:Int = 0
    var adl_Hygiene:Int = 0
    var adl_ReadingNews:Int = 0
    var adl_ReadingBooks:Int = 0
    var adl_EnjoyReading:Int = 0
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var result = BehaviorRelay<String>(value: "")
    
    func submitResult() {
        self.isLoading.accept(true)
        provider.request(.SubmitADLTest(driving: adl_driving, readingNews: adl_ReadingNews, hygiene: adl_Hygiene, readingBooks:adl_ReadingBooks, enjoyReading: adl_EnjoyReading, findThings: adl_FindingThings))
            .map(NetworkModels.SubmitTestsBaseResponse.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                        if let msg = response.message {
                            self.result.accept(msg.joined(separator: "\n"))
                        }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
}
