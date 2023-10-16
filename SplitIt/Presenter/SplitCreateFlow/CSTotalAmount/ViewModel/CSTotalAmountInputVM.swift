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
    
    let titleMessage = BehaviorSubject<String>(value: "")
    
    struct Input {
        let viewDidLoad: Driver<Void> // viewDidLoad
        let nextButtonTapSend: Driver<Void> // 다음 버튼
        let totalAmountTextFieldValue: Driver<String> // TitleTextField의 text
    }
    
    struct Output {
        let titleMessage: Driver<String>
        let presentCSMemberInputView: Driver<Void>
        let totalAmountTextFieldText: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let currentTitle = CreateStore.shared.getCurrentCSInfoTitle()
                self.titleMessage.onNext("[\(currentTitle)]의 총액은 얼마인가요?")
            })
            .disposed(by: disposeBag)
        
        let presentCSMemberInputView = input.nextButtonTapSend.asDriver()
        let totalAmountTextFieldValue = input.totalAmountTextFieldValue.asDriver(onErrorJustReturn: "")
        
        _ = input.nextButtonTapSend
            .withLatestFrom(input.totalAmountTextFieldValue)
            .drive(onNext: {
                CreateStore.shared.setCurrentCSInfoTotalAmount(totalAmount: Int($0) ?? 0)
                CreateStore.shared.printAll()
            })
            .disposed(by: disposeBag)

        return Output(titleMessage: titleMessage.asDriver(onErrorJustReturn: ""), presentCSMemberInputView: presentCSMemberInputView, totalAmountTextFieldText: totalAmountTextFieldValue)
    }
}
