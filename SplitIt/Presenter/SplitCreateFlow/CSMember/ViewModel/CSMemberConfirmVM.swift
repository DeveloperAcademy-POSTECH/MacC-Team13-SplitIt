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
    
    let memberList = BehaviorSubject<[String]>(value: [])
    let memberCount = BehaviorSubject<String>(value: "")
   
    struct Input {
        let viewDidLoad: Driver<Void> // viewDidLoad
        let nextButtonTapSend: Driver<Void> // 다음 버튼
    }
    
    struct Output {
        let memberCountText: Driver<String>
        let showExclCycle: Driver<Void> //필요
    }
    
    func transform(input: Input) -> Output {
        let showExclCycle = input.nextButtonTapSend.asDriver()
        
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let currentMember = CreateStore.shared.getCurrentCSInfoCSMember()
                let memberCount = currentMember.count
                let currentTitle = CreateStore.shared.getCurrentCSInfoTitle()
                self.memberList.onNext(currentMember)
                self.memberCount.onNext("총 \(memberCount)명")
            })
            .disposed(by: disposeBag)

        showExclCycle
            .withLatestFrom(self.memberList.asDriver(onErrorJustReturn: []))
            .drive(onNext: {
                CreateStore.shared.setCurrentCSInfoCSMember(members: $0)
                CreateStore.shared.printAll()
                // nextVC 구현
                
            })
            .disposed(by: disposeBag)

        return Output(memberCountText: memberCount.asDriver(onErrorJustReturn: ""),
                      showExclCycle: showExclCycle)
    }
}

