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
    var indexPath: IndexPath?
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    init() {
        
    }
    
    struct Input {
        let nextButtonTapped: Driver<Void>
        let price: Driver<String>
    }
    
    struct Output {
        let showExclItemTargetView: Driver<Void>
        let totalAmount: Driver<String>
        let title: Driver<String>
        let exclPrice: Driver<String>
        let textFieldEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let maxCurrency = 10000000
        let numberFormatter = NumberFormatterHelper()
        let title = BehaviorRelay<String>(value: "")
        let priceResult = BehaviorRelay<Int>(value: 0)
        let showExclItemTargetView = input.nextButtonTapped.asDriver()
        var currentExclItemName = ""
        var exclIdx = ""
        
        let totalAmountString = input.price
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map { min($0, maxCurrency) }
            .map { number in
                priceResult.accept(number)
                return number
            }
            .map { numberFormatter.formattedString(from: $0) }
            .asDriver(onErrorJustReturn: "0")
        
        let textFieldCountIsEmpty = input.price
            .map{ $0.count > 0 }
            .asDriver()
        
        if let indexPath = indexPath {
            let data = SplitRepository.share.exclItemArr.map { $0[indexPath.row] }
            let exclName = data.map { String($0.price) }.asDriver(onErrorJustReturn: "")
            
            data.map { $0.exclItemIdx }.subscribe { st in
                exclIdx = st
            }.disposed(by: disposeBag)
            
            data.map { $0.name }.subscribe { st in
                currentExclItemName = st
            }.disposed(by: disposeBag)
            title.accept(currentExclItemName)
            
            showExclItemTargetView
                .withLatestFrom(priceResult.asDriver())
                .drive(onNext: { price in
                    SplitRepository.share.editExclItemPrice(exclItemIdx: exclIdx, price: Int(price))
                })
                .disposed(by: disposeBag)
            
            return Output(showExclItemTargetView: showExclItemTargetView,
                          totalAmount: totalAmountString,
                          title: title.asDriver(),
                          exclPrice: exclName,
                          textFieldEmpty: textFieldCountIsEmpty)
        } else {
//            input.price
//                .map { Int($0) }
//                .compactMap { $0 }
//                .drive {
//                    SplitRepository.share.inputExclItemPrice(price: $0)
//                }
//                .disposed(by: disposeBag)
            
            showExclItemTargetView
                .withLatestFrom(priceResult.asDriver())
                .drive(onNext: { price in
                    print("\(price)")
                    SplitRepository.share.inputExclItemPrice(price: price)                })
                .disposed(by: disposeBag)
            
            return Output(showExclItemTargetView: showExclItemTargetView,
                          totalAmount: totalAmountString,
                          title: title.asDriver(),
                          exclPrice: Driver.just(""),
                          textFieldEmpty: textFieldCountIsEmpty)
        }
        
    }
    
    func mapTitleMessage(_ text: String) -> String {
        return "\(text) 값은 총 얼마인가요?"
    }
}

