//
//  CSTitleInputVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/15.
//

import RxSwift
import RxCocoa
import UIKit

class CSTitleInputVM {
    
    var disposeBag = DisposeBag()
    
    let maxTextCount = 12
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let title: Driver<String> // TitleTextField의 text
    }
    
    struct Output {
        let showCSTotalAmountView: Driver<Void>
        let titleCount: Driver<String>
        let textFieldIsValid: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let title = input.title
        let showCSTotalAmountView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)

        showCSTotalAmountView
            .asDriver()
            .withLatestFrom(input.title)
            .drive(onNext: {
                SplitRepository.share.inputCSInfoWithTitle(title: $0)
            })
            .disposed(by: disposeBag)
        
        title
            .map { title in
                let currentTextCount = title.count > self.maxTextCount ? title.count - 1 : title.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(textFieldCount)
            .disposed(by: disposeBag)
        
        title
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(textFieldIsValid)
            .disposed(by: disposeBag)
        
        return Output(showCSTotalAmountView: showCSTotalAmountView.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver())
    }

}

