//
//  MemberLogVM.swift
//  SplitIt
//
//  Created by cho on 2023/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class MemberLogVM {
    
    var disposeBag = DisposeBag()
    var memberLogService: MemberLogServiceType
    
    init(memberLogService: MemberLogServiceType) {
        self.memberLogService = memberLogService
    }
    
    struct Input {
        let removeLogIdx: BehaviorRelay<String>
        let backButtonTapped: ControlEvent<Void>
        let alertRightButtonTapped: Driver<Void>
    }
    
    struct Output {
        let memberList: BehaviorRelay<[MemberLog]>
        let moveToBackView: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let memberList = BehaviorRelay<[MemberLog]>(value: [])
        let moveToBackView = input.backButtonTapped.asDriver()
        
        memberLogService.fetchMemberLog()
            .asDriver(onErrorJustReturn: [])
            .drive(memberList)
            .disposed(by: disposeBag)
        
        input.alertRightButtonTapped
            .drive { [weak self] _ in
                self?.memberLogService.deleteAllMemberLog()
            }
            .disposed(by: disposeBag)
        
        input.removeLogIdx
            .asDriver()
            .drive(onNext: { [weak self] idx in
                if idx != "" {
                    self?.memberLogService.deleteMemberLog(memberLogIdx: idx)
                }
            })
            .disposed(by: disposeBag)

        return Output(memberList: memberList,
                      moveToBackView: moveToBackView)
    }
}

