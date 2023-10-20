//
//  ExclItemPriceInputVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemPriceInputVM {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTapped: Driver<Void>
        let price: Driver<String>
    }
    
    struct Output {
        let showExclItemTargetView: Driver<Void>
        let totalAmount: Driver<String>
        let title: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let maxCurrency = 10000000
        let currentExclItemName = CreateStore.shared.getCurrentExclItemName()
        let numberFormatter = NumberFormatterHelper()
        
        let title = BehaviorRelay<String>(value: "")
        let priceResult = BehaviorRelay<Int>(value: 0)
        let showExclItemTargetView = input.nextButtonTapped.asDriver()
        
        title.accept(currentExclItemName)
        
        let totalAmountString = input.price
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map { min($0, maxCurrency) }
            .map { number in
                priceResult.accept(number)
                return number
            }
            .map { numberFormatter.formattedString(from: $0) }
            .asDriver(onErrorJustReturn: "0")
        
        showExclItemTargetView
            .withLatestFrom(priceResult.asDriver())
            .drive(onNext: {
                SplitRepository.share.inputExclItemPrice(price: $0)
            })
            .disposed(by: disposeBag)
        
        return Output(showExclItemTargetView: showExclItemTargetView,
                      totalAmount: totalAmountString,
                      title: title.asDriver())
    }
    
    func mapTitleMessage(_ text: String) -> String {
        return "\(text) 값은 총 얼마인가요?"
    }
}

