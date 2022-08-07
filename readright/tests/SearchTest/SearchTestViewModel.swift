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
    var vst_duration:Float = 0
    let disposeBag = DisposeBag()
    var error = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var result = BehaviorRelay<String>(value: "")
    
    func submitResult(_ vst_itemsDirections:[Int], _ vst_RTs:[Float]) {
//        var questions:[] = [[NSMutableArray alloc] init];
//        for (int i = 0; i < NUMBER_OF_VISIUAL_SEARCH_TRIALS; i++) {
//            [questions addObject:@{@"Question": [NSNumber numberWithInt:i], @"Side": ( vst_itemsDirections[i] == -1 ) ? @"R" : @"L", @"RT": [NSNumber numberWithFloat:vst_RTs[i]]}];
//        }
        self.isLoading.accept(true)
        provider.request(.SubmitSearchTest(score: 0, duration: 0.0))
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
