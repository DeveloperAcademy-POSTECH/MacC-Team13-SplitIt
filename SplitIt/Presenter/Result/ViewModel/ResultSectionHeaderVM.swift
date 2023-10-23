//
//  ResultSectionHeaderVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/23.
//

import RxSwift
import RxCocoa
import UIKit

class ResultSectionHeaderVM {
    
    var disposeBag = DisposeBag()

    struct Input {
        let toggleButtonTap: Driver<IndexPath>
    }
    
    struct Output {
        let toggleButtonTapped: BehaviorRelay<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let toggleButtonTapped = BehaviorRelay<IndexPath>(value: IndexPath())
        
        input.toggleButtonTap
            .drive(toggleButtonTapped)
            .disposed(by: disposeBag)
        

        return Output(toggleButtonTapped: toggleButtonTapped)
    }
}
