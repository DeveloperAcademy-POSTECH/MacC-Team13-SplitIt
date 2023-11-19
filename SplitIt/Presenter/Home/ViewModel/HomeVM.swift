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
    }
    
    struct Output {
        let showCreateSplit: Driver<Void>
        let showInfoView: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let showCreateSplit = input.splitItButtonTapped.asDriver()
        let showInfoView = input.myInfoButtonTapped.asDriver()

        showCreateSplit
            .drive(onNext: {
                SplitRepository.share.createDatasForCreateFlow()
                UserDefaults.standard.set("Create", forKey: "ShareFlow")
                UserDefaults.standard.set("PopUp", forKey: "MyInfoFlow")
            })
            .disposed(by: disposeBag)
        
        showInfoView
            .drive(onNext: {
                UserDefaults.standard.set("History", forKey: "ShareFlow")
                UserDefaults.standard.set("Setting", forKey: "MyInfoFlow")
            })
            .disposed(by: disposeBag)

        return Output(showCreateSplit: showCreateSplit,
                      showInfoView: showInfoView)
    }
}

