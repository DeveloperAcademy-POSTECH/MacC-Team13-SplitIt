//
//  CSTotalAmountEditVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/20.
//

import RxSwift
import RxCocoa
import UIKit

class CSTotalAmountEditVM {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTapped: Driver<Void>
        let totalAmount: Driver<String>
    }
    
    struct Output {
        let showCSMemberInputView: Driver<Void>
        let totalAmount: Driver<String>
        let totalAmountString: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let totalAmountResult = BehaviorRelay<Int>(value: 0)
        let numberFormatter = NumberFormatterHelper()
        let showCSMemberInputView = input.nextButtonTapped.asDriver()
        let maxCurrency = 10000000
        let data = SplitRepository.share.csInfoArr.map { $0.first! }
        let tfString = data.map { "\($0.totalAmount)" }.asObservable()
        
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
                SplitRepository.share.editCSInfoTotalAcount(totalAcount: $0)
            })
            .disposed(by: disposeBag)
        
        
        return Output(showCSMemberInputView: showCSMemberInputView,
                      totalAmount: totalAmountString, totalAmountString: tfString)
    }
}

