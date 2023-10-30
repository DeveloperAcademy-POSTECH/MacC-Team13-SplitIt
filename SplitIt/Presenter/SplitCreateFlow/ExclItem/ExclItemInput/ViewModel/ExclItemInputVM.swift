//
//  ExclItemInputVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/29.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemInputVM {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let exclItemAddButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showResultView: Driver<Void>
        let exclItems: BehaviorRelay<[String]>
        let nextButtonIsEnable: Driver<Bool>
        let showExclItemInfoModal: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let showResultView = input.nextButtonTapped
        let showExclItemInfoModal = input.exclItemAddButtonTapped
        let nextButtonIsEnable: Driver<Bool>
        
        let exclItems = BehaviorRelay<[String]>(value: ["1","d","4"])
        
        nextButtonIsEnable = exclItems
            .map{ $0.count > 0 }
            .asDriver(onErrorJustReturn: false)
        
        
  
        
        return Output(showResultView: showResultView.asDriver(),
                      exclItems: exclItems,
                      nextButtonIsEnable: nextButtonIsEnable,
                      showExclItemInfoModal: showExclItemInfoModal.asDriver())
    }

}

