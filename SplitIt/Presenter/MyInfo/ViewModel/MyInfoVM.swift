//
//  MyInfoVM.swift
//  SplitIt
//
//  Created by cho on 2023/10/18.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class MyInfoVM: UIViewController {
    
    let userData = UserData.shared.userData
    let payData = PayData.shared.payData
    let disposeBag = DisposeBag()
    
    struct Input {
        let accountEditBtnTapped: Driver<Void>
        let privacyBtnTapped: Driver<Void>
        let friendListViewTapped: Observable<Void>
        let exclItemViewTapped: Observable<Void>
    }
    
    struct Output {
        let moveToAccountEditView: Driver<Void>
        let moveToPrivacyView: Driver<Void>
        let moveTofriendListView: Observable<Void>
        let moveToExclItemListView: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let accountEditBtnTapped = input.accountEditBtnTapped
        let privacyBtnTapped = input.privacyBtnTapped
        let friendListViewTapped = input.friendListViewTapped
        let exclItemViewTapped = input.exclItemViewTapped


        let output = Output(moveToAccountEditView: accountEditBtnTapped,
                            moveToPrivacyView: privacyBtnTapped,
                            moveTofriendListView: friendListViewTapped,
                            moveToExclItemListView: exclItemViewTapped
                            )
        
        return output
    }
    
    
}


