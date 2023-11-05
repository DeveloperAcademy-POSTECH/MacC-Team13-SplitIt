//
//  HomeViewModel.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/15.
//

import UIKit
import RxCocoa
import RxSwift

class HomeVM {
    var disposeBag = DisposeBag()
    
    struct Input {
        let splitItButtonTapped: ControlEvent<Void>
        let myInfoButtonTapped: ControlEvent<Void>
        let recentSplitButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showCreateSplit: Driver<Void>
        let showInfoView: Driver<Void>
        let showHistoryView: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let showCreateSplit = input.splitItButtonTapped.asDriver()
        let showInfoView = input.myInfoButtonTapped.asDriver()
        let showHistoryView = input.recentSplitButtonTapped.asDriver()
        
        showInfoView
            .drive(onNext: {
                if UserDefaults.standard.object(forKey: "tossPay") == nil {
                    UserDefaults.standard.set(false, forKey: "tossPay")
                }
                if UserDefaults.standard.object(forKey: "kakaoPay") == nil {
                    UserDefaults.standard.set(false, forKey: "kakaoPay")
                }
                if UserDefaults.standard.object(forKey: "naverPay") == nil {
                    UserDefaults.standard.set(false, forKey: "naverPay")
                }
                if UserDefaults.standard.object(forKey: "userAccount") == nil {
                    UserDefaults.standard.set("", forKey: "userAccount")
                }
                if UserDefaults.standard.object(forKey: "userNickName") == nil {
                    UserDefaults.standard.set("", forKey: "userNickName")
                }
                if UserDefaults.standard.object(forKey: "userName") == nil {
                    UserDefaults.standard.set("", forKey: "userName")
                }
                if UserDefaults.standard.object(forKey: "userBank") == nil {
                    UserDefaults.standard.set("", forKey: "userBank")
                }
                
            })
            .disposed(by: disposeBag)
        
        
        showCreateSplit
            .drive(onNext: {
                SplitRepository.share.createDatasForCreateFlow()
            })
            .disposed(by: disposeBag)

        return Output(showCreateSplit: showCreateSplit,
                      showInfoView: showInfoView,
                      showHistoryView: showHistoryView)
    }
}

