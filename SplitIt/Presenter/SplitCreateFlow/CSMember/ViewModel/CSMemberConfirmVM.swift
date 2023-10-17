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
        let showExclCycle: Driver<Void> //필요
    }
    
    func transform(input: Input) -> Output {
        let showExclCycle = input.nextButtonTapSend.asDriver()
        
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let currentMember = CreateStore.shared.getCurrentCSInfoCSMember()
                let currentTitle = CreateStore.shared.getCurrentCSInfoTitle()
                // MARK: currentTotalAmount도 얻어와야함
                self.memberList.onNext(currentMember)
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

        return Output(showExclCycle: showExclCycle)
    }
}

