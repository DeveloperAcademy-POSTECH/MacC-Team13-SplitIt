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

        return Output(showCreateSplit: showCreateSplit,
                      showInfoView: showInfoView)
    }
}

