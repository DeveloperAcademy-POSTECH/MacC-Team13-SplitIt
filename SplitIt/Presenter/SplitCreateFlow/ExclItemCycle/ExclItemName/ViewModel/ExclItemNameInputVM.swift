//
//  ExclItemNameInputVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemNameInputVM {
    
    var disposeBag = DisposeBag()
    
    let maxTextCount = 8
    struct Input {
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let name: Driver<String>
    }
    
    struct Output {
        let showExclItemPriceView: Driver<Void>
        let nameCount: Driver<String>
        let textFieldIsValid: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let name = input.name
        let showExclItemPriceView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)

        showExclItemPriceView
            .asDriver()
            .withLatestFrom(input.name)
            .drive(onNext: {
                SplitRepository.share.createExclItemWithName(name: $0)
            })
            .disposed(by: disposeBag)
        
        name
            .map { text in
                let currentTextCount = text.count > self.maxTextCount ? text.count - 1 : text.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(textFieldCount)
            .disposed(by: disposeBag)
        
        name
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(textFieldIsValid)
            .disposed(by: disposeBag)
        
        return Output(showExclItemPriceView: showExclItemPriceView.asDriver(),
                      nameCount: textFieldCount.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver())
    }

}

