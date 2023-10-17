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
    
    let titleMessage = BehaviorSubject<String>(value: "")
    let memberList = BehaviorSubject<[String]>(value: [])
    let memberCount = BehaviorSubject<String>(value: "")
   
    struct Input {
        let viewDidLoad: Driver<Void> // viewDidLoad
        let nextButtonTapSend: Driver<Void> // 다음 버튼
    }
    
    struct Output {
        let titleMessage: Driver<String>
        let memberCountText: Driver<String>
        let memberList: BehaviorSubject<[String]>
        let presentExclCycle: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        // 현재 차수의 members 세팅
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let currentMember = CreateStore.shared.getCurrentCSInfoCSMember()
                let memberCount = currentMember.count
                let currentTitle = CreateStore.shared.getCurrentCSInfoTitle()
                self.memberList.onNext(currentMember)
                self.titleMessage.onNext("[\(currentTitle)] 정산 인원")
                self.memberCount.onNext("총 \(memberCount)명")
            })
            .disposed(by: disposeBag)
        
      
        let presentExclCycle = input.nextButtonTapSend.asDriver()
        
        presentExclCycle
            .withLatestFrom(self.memberList.asDriver(onErrorJustReturn: []))
            .drive(onNext: {
                CreateStore.shared.setCurrentCSInfoCSMember(members: $0)
                CreateStore.shared.printAll()
                // nextVC 구현
                
            })
            .disposed(by: disposeBag)
        
        
        return Output(titleMessage: titleMessage.asDriver(onErrorJustReturn: ""), memberCountText: memberCount.asDriver(onErrorJustReturn: ""), memberList: memberList, presentExclCycle: presentExclCycle)
    }
}

