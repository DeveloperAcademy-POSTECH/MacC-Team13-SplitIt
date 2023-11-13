//
//  MyInfoVM.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class MyInfoVM: UIViewController {
    
    let disposeBag = DisposeBag()
    let repo = SplitRepository.share
    let userDefault = UserDefaults.standard
    
    
    struct Input {
        let privacyBtnTapped: Driver<Void>
        let friendListViewTapped: Observable<Void>
        let editAccountViewTapped: Observable<Void>
        let emptyEditAccountViewTapped: Observable<Void>
        let madeByWCCTBtnTapped: Driver<Void>
    }
    
    struct Output {
        let moveToPrivacyView: Driver<Void>
        let moveTofriendListView: Observable<Void>
        let moveToEditAccountView: Observable<Void>
        let moveToInitAccountView: Observable<Void>
        let moveToMadeByWCCT: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let privacyBtnTapped = input.privacyBtnTapped
        let friendListViewTapped = input.friendListViewTapped
        let editAccountViewTap = input.editAccountViewTapped
        let emptyEditAccountViewTapped = input.emptyEditAccountViewTapped
        let madeByWCCTBtnTapped = input.madeByWCCTBtnTapped
        repo.fetchMemberLog()

        
        let output = Output(moveToPrivacyView: privacyBtnTapped,
                            moveTofriendListView: friendListViewTapped,
                            moveToEditAccountView: editAccountViewTap,
                            moveToInitAccountView: emptyEditAccountViewTapped,
                            moveToMadeByWCCT: madeByWCCTBtnTapped
        )
        
        return output
    }
    
    
}



