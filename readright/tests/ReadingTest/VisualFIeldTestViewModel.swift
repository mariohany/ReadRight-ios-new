//
//  VisualFIeldTestViewModel.swift
//  readright
//
//  Created by user225703 on 7/12/22.
//

import Foundation
import RxSwift
import RxRelay


class VisualFieldViewModel {
    var vfTDuration:Float = 0.0
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var result = BehaviorRelay<String>(value: "")
    
    func submitResult(_ answersIDs:[Int], _ answersFlow:[Int], _ dotsHitted:[Int]) {
        self.isLoading.accept(true)
        //Fill the nodesAnswers array of dictionaries
        var nodesAnswers:[NetworkModels.NodesAnswer] = []
        for i in 0 ..< Constants.NUMBER_OF_VISUAL_FIELD_QUESTIONS {
            nodesAnswers.append(NetworkModels.NodesAnswer(question: i, nodeNo: answersFlow[i], answer: answersIDs[i]))
        }
        //Fill the nodesHitted array of dictionaries
        var nodesHitted:[NetworkModels.NodesHits] = []
        for i in 0 ..< Constants.NUMBER_OF_VISIUAL_FIELD_DOTS {
            nodesHitted.append(NetworkModels.NodesHits(dot: i, shown: 3, hit: dotsHitted[i]))
        }
        let model = NetworkModels.VisualFieldTestRequest(duration: vfTDuration, nodesAnswers: nodesAnswers, nodesHits: nodesHitted)
        
        provider.request(.SubmitVisualFieldTest(model: model))
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
