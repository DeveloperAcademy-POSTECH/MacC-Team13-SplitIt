//
//  JSDetailVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/30.
//

import RxSwift
import Foundation
import RxCocoa
import UIKit

final class JSDetailVM {
    var disposeBag = DisposeBag()
    
    let dataModel = SplitRepository.share
    let maxTextCount = 8
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void>
        let title: Driver<String>
        let csEditTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let pushNextView: Driver<Void>
        let titleCount: Driver<String>
        let textFieldIsValid: Driver<Bool>
        let textFieldIsEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let title = input.title
        let showNextView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        let textFieldCountIsEmpty: Driver<Bool>

        showNextView
            .asDriver()
            .withLatestFrom(input.title)
            .drive(onNext: {
//                SplitRepository.share.inputCSInfoWithTitle(title: $0)
                print("\($0)")
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
        
        textFieldCountIsEmpty = input.title
            .map{ $0.count > 0 }
            .asDriver()
        
        return Output(pushNextView: showNextView.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver(),
                      textFieldIsEmpty: textFieldCountIsEmpty)
    }

}

