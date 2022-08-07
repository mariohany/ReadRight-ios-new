//
//  NeglectViewModel.swift
//  readright
//
//  Created by user225703 on 7/22/22.
//

import Foundation
import RxSwift
import RxRelay

class NeglectViewModel {
    var vnt_score:Int = 0
    var vnt_targets:Int = 0
    var vnt_distractors:Int = 0
    var vnt_revisits:Int = 0
    var vnt_duration:Int = 0
    var vnt_X:Int = 0
    var vnt_Y:Int = 0
    var numTotalTargets:Int = 0
    var numTotalDistractors:Int = 0
    var numTargetsMissed:Int = 0
    var numTargetsMissedLeft:Int = 0
    var numTargetsMissedRight:Int = 0
    var numRevisits:Int = 0
    var numRevisitsLeft:Int = 0
    var numRevisitsRight:Int = 0
    var meanX:Int = 0
    var meanY:Int = 0
    var elements:[NetworkModels.Elements] = []
    var hitsPath:[NetworkModels.HitsPath] = []
    
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var result = BehaviorRelay<String>(value: "")
    
    func submitResult() {
        self.isLoading.accept(true)
        provider.request(.SubmitVisualNeglectTest(score: vnt_score, duration: vnt_duration, targets: vnt_targets, distractors: vnt_distractors, revisits: vnt_revisits, x: vnt_X, y: vnt_Y, numTotalTargets: numTotalTargets, numTotalDistractors: numTotalDistractors, numTargetsMissed: numTargetsMissed, numTargetsMissedLeft: numTargetsMissedLeft, numTargetsMissedRight: numTargetsMissedRight, numRevisits: numRevisits, numRevisitsLeft: numRevisitsLeft, numRevisitsRight: numRevisitsRight, meanXTargets: meanX, meanYTargets: meanY, elements: elements, hitsPath: hitsPath))
            .map(NetworkModels.SubmitTestsBaseResponse.self)
            .subscribe { (result) in
                self.isLoading.accept(false)
                switch result {
                    case .success(let response):
                    if let success = response.success, success {
                        if let msg = response.message {
                            self.result.accept(msg)
                        }
                    }else{
                        if let msg = response.message {
                            self.error.accept(msg)
                        }
                    }
                    case .error(let error):
                        self.error.accept((error as? NetworkModels.NetworkingError)?.getLocalizedDescription() ?? "")
                }
            }.disposed(by: disposeBag)
    }
}
