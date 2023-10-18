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
        let showWanView: Driver<Void>
        let showMoanaView: Driver<Void>
        let showJerryView: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let showWanView = input.splitItButtonTapped.asDriver()
        let showMoanaView = input.myInfoButtonTapped.asDriver()
        let showJerryView = input.recentSplitButtonTapped.asDriver()

        return Output(showWanView: showWanView,
                      showMoanaView: showMoanaView,
                      showJerryView: showJerryView)
    }
}

