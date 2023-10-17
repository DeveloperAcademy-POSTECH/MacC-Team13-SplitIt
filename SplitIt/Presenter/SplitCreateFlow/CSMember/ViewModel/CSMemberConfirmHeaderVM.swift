//
//  CSMemberConfirmHeaderVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import RxSwift
import RxCocoa
import UIKit

class CSMemberConfirmHeaderVM {
    
    var disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: Driver<Void> // viewDidLoad
    }
    
    struct Output {
        let title: Driver<String>
        let totalAmount: Driver<String>
        let memberCount: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let numberFormatter = NumberFormatterHelper()
        let memberList = BehaviorRelay<[String]>(value: [])
        let title = BehaviorRelay<String>(value: "")
        let totalAmount = BehaviorRelay<Int>(value: 0)
        let memberCount = BehaviorRelay<String>(value: "")
        let totalAmountDriver = BehaviorRelay<String>(value: "")
        
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let currentMember = CreateStore.shared.getCurrentCSInfoCSMember()
                let currentTitle = CreateStore.shared.getCurrentCSInfoTitle()
                let currentTotalAmount = CreateStore.shared.getCurrentCSInfoTotalAmount()
                // MARK: currentTotalAmount도 얻어와야함
                memberList.accept(currentMember)
                title.accept(currentTitle)
                totalAmount.accept(currentTotalAmount)
            })
            .disposed(by: disposeBag)
        
        memberList
            .asDriver()
            .map { String("총 \($0.count)인") }
            .drive(memberCount)
            .disposed(by: disposeBag)
        
        totalAmount
            .asDriver()
            .map { numberFormatter.formattedString(from: $0) }
            .map { String("\($0) KRW")}
            .drive(totalAmountDriver)
            .disposed(by: disposeBag)

        return Output(title: title.asDriver(onErrorJustReturn: ""),
                      totalAmount: totalAmountDriver.asDriver(onErrorJustReturn: ""),
                      memberCount: memberCount.asDriver(onErrorJustReturn: ""))
    }
}


