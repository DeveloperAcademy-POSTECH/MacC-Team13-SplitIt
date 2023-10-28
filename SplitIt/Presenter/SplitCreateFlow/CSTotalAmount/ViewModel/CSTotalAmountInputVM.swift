//
//  CSTotalAmountVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/16.
//

import RxSwift
import RxCocoa
import UIKit

class CSTotalAmountInputVM {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTapped: Driver<Void>
        let totalAmount: Driver<String>
    }
    
    struct Output {
        let showCSMemberInputView: Driver<Void>
        let totalAmount: Driver<String>
        let textFieldIsEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let totalAmountResult = BehaviorRelay<Int>(value: 0)
        let numberFormatter = NumberFormatterHelper()
        let showCSMemberInputView = input.nextButtonTapped.asDriver()
        let textFieldCountIsEmpty: Driver<Bool>
        let maxCurrency = 10000000
        
        let totalAmountString = input.totalAmount
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map { min($0, maxCurrency) }
            .map { number in
                totalAmountResult.accept(number)
                return number
            }
            .map { numberFormatter.formattedString(from: $0) }
            .asDriver(onErrorJustReturn: "0")
        
        showCSMemberInputView
            .withLatestFrom(totalAmountResult.asDriver())
            .drive(onNext: {
                SplitRepository.share.inputCSInfoWithTotalAmount(totalAmount: $0)
            })
            .disposed(by: disposeBag)
        
        textFieldCountIsEmpty = input.totalAmount
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map{ $0 != 0 }
            .asDriver()
        
        return Output(showCSMemberInputView: showCSMemberInputView,
                      totalAmount: totalAmountString,
                      textFieldIsEmpty: textFieldCountIsEmpty)
    }
}
