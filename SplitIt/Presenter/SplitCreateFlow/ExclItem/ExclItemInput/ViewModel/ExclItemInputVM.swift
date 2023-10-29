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
    }
    
    struct Output {
        let showCSTotalAmountView: Driver<Void>
//        let nextButtonIsEnable: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let showCSTotalAmountView = input.nextButtonTapped
        
        let nextButtonIsEnable: Driver<Bool>
        
//        nextButtonIsEnable = Driver.combineLatest(titleTextFieldCountIsEmpty.asDriver(), totalAmountTextFieldCountIsEmpty.asDriver())
//            .map{ $0 && $1 }
//            .asDriver()
  
        
        return Output(showCSTotalAmountView: showCSTotalAmountView.asDriver())
    }

}

