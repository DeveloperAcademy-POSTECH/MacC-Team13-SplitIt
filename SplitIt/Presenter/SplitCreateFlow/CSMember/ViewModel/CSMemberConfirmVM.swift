//
//  CSMemberConfirmVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import RxSwift
import RxCocoa
import UIKit

class CSMemberConfirmVM {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Driver<Bool>
        let smartSplitTap: Driver<Void>
        let equalSplitTap: Driver<Void>
    }
    
    struct Output {
        let showSmartSplitCycle: Driver<Void>
        let showEqualSplitCycle: Driver<Void>
        let memberList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        let showSmartSplitCycle = input.smartSplitTap.asDriver()
        let showEqualSplitCycle = input.equalSplitTap.asDriver()
        let memberList = BehaviorSubject<[String]>(value: [])
        let currentMembers = SplitRepository.share.csMemberArr
        
        input.viewWillAppear
            .drive(onNext: { _ in
                memberList.onNext(currentMembers.value.map{$0.name})
            })
            .disposed(by: disposeBag)
        
//        showSmartSplitCycle
//            .withLatestFrom(memberList.asDriver(onErrorJustReturn: []))
//            .drive(onNext: {
//                CreateStore.shared.setCurrentCSInfoCSMember(members: $0)
//                CreateStore.shared.printAll()
//            })
//            .disposed(by: disposeBag)

        return Output(showSmartSplitCycle: showSmartSplitCycle,
                      showEqualSplitCycle: showEqualSplitCycle,
                      memberList: memberList)
    }
}

