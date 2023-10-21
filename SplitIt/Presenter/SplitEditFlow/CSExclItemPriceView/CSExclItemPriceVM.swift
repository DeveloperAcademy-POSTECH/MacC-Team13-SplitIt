//
//  CSExclItemPriceVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/21.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemPriceEditVM {
    
    var disposeBag = DisposeBag()
    var indexPath: IndexPath
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    struct Input {
        let nextButtonTapped: Driver<Void>
        let price: Driver<String>
    }
    
    struct Output {
        let showExclItemTargetView: Driver<Void>
        let totalAmount: Driver<String>
        let title: Driver<String>
        let exclPrice: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let maxCurrency = 10000000
        let currentExclItemName = CreateStore.shared.getCurrentExclItemName()
        let numberFormatter = NumberFormatterHelper()
        
        let title = BehaviorRelay<String>(value: "")
        let priceResult = BehaviorRelay<Int>(value: 0)
        let showExclItemTargetView = input.nextButtonTapped.asDriver()
        
        let data = SplitRepository.share.exclItemArr.map { $0[self.indexPath.row] }
        var exclIdx = ""
        let exclName = data.map { String($0.price) }.asObservable()
        
        data.map { $0.exclItemIdx }.subscribe { st in
            exclIdx = st
        }.disposed(by: disposeBag)
        
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
            .drive(onNext: { price in
                SplitRepository.share.editExclItemPrice(exclItemIdx: exclIdx, price: Int(price))
            })
            .disposed(by: disposeBag)
        
        return Output(showExclItemTargetView: showExclItemTargetView,
                      totalAmount: totalAmountString,
                      title: title.asDriver(),
                      exclPrice: exclName)
    }
    
    func mapTitleMessage(_ text: String) -> String {
        return "\(text) 값은 총 얼마인가요?"
    }
}
