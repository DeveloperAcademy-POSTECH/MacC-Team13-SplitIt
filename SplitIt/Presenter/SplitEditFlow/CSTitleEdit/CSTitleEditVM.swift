//
//  CSTitleEditVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/20.
//

import RxSwift
import RxCocoa
import UIKit

class CSTitleEditVM {
    
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
        let textFieldString: Observable<String>
        let textfieldEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let title = input.title
        let showCSTotalAmountView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        let data = SplitRepository.share.csInfoArr.map { $0.first! }.asObservable()
        
        showCSTotalAmountView
            .asDriver()
            .withLatestFrom(input.title)
            .drive(onNext: {
                print($0)
                SplitRepository.share.editCSInfoTitle(title: $0)
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
        
        let tfString = data.map { $0.title }.asObservable()
        
        let textFieldCountIsEmpty = input.title
            .map{ $0.count > 0 }
            .asDriver()
        
        return Output(showCSTotalAmountView: showCSTotalAmountView.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver(),
                      textFieldString: tfString,
                      textfieldEmpty: textFieldCountIsEmpty
        )
    }

}

