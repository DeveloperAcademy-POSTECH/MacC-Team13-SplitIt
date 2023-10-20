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
    
    let payData = PayData.shared.payData
    let disposeBag = DisposeBag()
    
    let repo = SplitRepository.share
    let userDefault = UserDefaults.standard
    
    
    struct Input {
        let privacyBtnTapped: Driver<Void>
        let friendListViewTapped: Observable<Void>
        let exclItemViewTapped: Observable<Void>
        let editAccountViewTapped: Observable<Void>
    }
    
    struct Output {
        let moveToPrivacyView: Driver<Void>
        let moveTofriendListView: Observable<Void>
        let moveToExclItemListView: Observable<Void>
        let moveToEditAccountView: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let privacyBtnTapped = input.privacyBtnTapped
        let friendListViewTapped = input.friendListViewTapped
        let exclItemViewTapped = input.exclItemViewTapped
        let editAccountViewTap = input.editAccountViewTapped
        
        repo.fetchMemberLog()
        
        userDefault.set(false, forKey: "tossPay")
        userDefault.set(false, forKey: "kakaoPay")
        userDefault.set(false, forKey: "naverPay")
        
        let output = Output(moveToPrivacyView: privacyBtnTapped,
                            moveTofriendListView: friendListViewTapped,
                            moveToExclItemListView: exclItemViewTapped,
                            moveToEditAccountView: editAccountViewTap
        )
        
        return output
    }
    
    
}



