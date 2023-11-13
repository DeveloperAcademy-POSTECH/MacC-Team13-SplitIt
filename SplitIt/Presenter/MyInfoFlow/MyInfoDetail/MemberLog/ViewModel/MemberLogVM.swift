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
    
    var inputFriend = ""

    init() {
        memberList = BehaviorRelay<[MemberLog]>(value: SplitRepository.share.memberLogArr.value.sorted { $0.name < $1.name })
    }

    struct Input {
        let inputFriendName: Observable<String>
    }
    
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        let inputFriendName = input.inputFriendName
        repo.fetchMemberLog()

        inputFriendName
            .bind(onNext: { [self] text in
                inputFriend = text
            })
            .disposed(by: disposeBag)
        
        let output = Output()
        return output
    }

}

