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
    
    let repo = SplitRepository.share
    var memberList: BehaviorRelay<[MemberLog]>
    var disposeBag = DisposeBag()
    

    init() {
        memberList = BehaviorRelay<[MemberLog]>(value: SplitRepository.share.memberLogArr.value.sorted { $0.name < $1.name })
    }

    struct Input {
        let deleteBtnTapped: Driver<Void>
        
    }
    
    
    struct Output {
        let showAlertAllDelete: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let deleteBtnTapped = input.deleteBtnTapped

        repo.fetchMemberLog()

        
        
        let output = Output(showAlertAllDelete: deleteBtnTapped)
        return output
    }

}

