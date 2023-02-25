//
//  SearchTestViewModel.swift
//  readright
//
//  Created by user225703 on 7/18/22.
//

import Foundation
import RxSwift
import RxRelay

class SearchTestViewModel {
    var vst_score:Int = 0
    var vst_duration:Double = 0
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var result = BehaviorRelay<String>(value: "")
    
    func submitResult(_ vst_itemsDirections:[Int], _ vst_RTs:[Double]) {
        let model = NetworkModels.SearchTestRequest(score: vst_score, duration: vst_duration, q0_side: getSide(vst_itemsDirections[0]), q1_side: getSide(vst_itemsDirections[1]), q2_side: getSide(vst_itemsDirections[2]), q3_side: getSide(vst_itemsDirections[3]), q4_side: getSide(vst_itemsDirections[4]), q5_side: getSide(vst_itemsDirections[5]), q6_side: getSide(vst_itemsDirections[6]), q7_side: getSide(vst_itemsDirections[7]), q8_side: getSide(vst_itemsDirections[8]), q9_side: getSide(vst_itemsDirections[9]), q10_side: getSide(vst_itemsDirections[10]), q11_side: getSide(vst_itemsDirections[11]), q12_side: getSide(vst_itemsDirections[12]), q13_side: getSide(vst_itemsDirections[13]), q14_side: getSide(vst_itemsDirections[14]), q15_side: getSide(vst_itemsDirections[15]), q16_side: getSide(vst_itemsDirections[16]), q0_rt: vst_RTs[0], q1_rt: vst_RTs[1], q2_rt: vst_RTs[2], q3_rt: vst_RTs[3], q4_rt: vst_RTs[4], q5_rt: vst_RTs[5], q6_rt: vst_RTs[6], q7_rt: vst_RTs[7], q8_rt: vst_RTs[8], q9_rt: vst_RTs[9], q10_rt: vst_RTs[10], q11_rt: vst_RTs[11], q12_rt: vst_RTs[12], q13_rt: vst_RTs[13], q14_rt: vst_RTs[14], q15_rt: vst_RTs[15], q16_rt: vst_RTs[16])
        self.isLoading.accept(true)
        provider.request(.SubmitSearchTest(model: model))
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
    
    func getSide(_ side:Int) -> String {
        if side == -1 {
            return "R"
        }else{
            return "L"
        }
    }
}

extension Float {
    mutating func myRound() -> Double {
        return (1000 * Double(self)).rounded() / 1000
    }
}
