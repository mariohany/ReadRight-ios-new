//
//  ReadingTestViewModel.swift
//  readright
//
//  Created by user225703 on 7/10/22.
//

import Foundation
import UIKit
import RxSwift
import RxRelay


class ReadingTestViewModel {
    var tp_Passage1:Int = 0
    var tp_Passage2:Int = 0
    var tp_Passage3:Int = 0
    var tp_Answer1:Int = 0
    var tp_Answer2:Int = 0
    var tp_Answer3:Int = 0
    var tp_ReadingSpeed:Int = 0
    var idPassage1:Int = 0
    var idPassage2:Int = 0
    var idPassage3:Int = 0
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var result = BehaviorRelay<Bool?>(value: nil)
    
    func submitResult(_ stage:Int) {
        self.isLoading.accept(true)
        provider.request(.SubmitReadingTest(stage: stage, passage1: tp_Passage1, passage2: tp_Passage2, passage3: tp_Passage3, answer1: tp_Answer1, answer2: tp_Answer2, answer3: tp_Answer3, readingSpeed: tp_ReadingSpeed, idPassage1: idPassage1, idPassage2: idPassage2, idPassage3: idPassage3))
            .map(NetworkModels.SubmitTestsBaseResponse.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
//                    if let success = response.success, success {
//                        if let msg = response.message {
                            self.result.accept(true)
//                        }
//                    }else{
//                        if let msg = response.message {
//                            self.error.accept(msg)
//                        }
//                    }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    
}
