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
        let wanButtonTapped: ControlEvent<Void>
        let moanaButtonTapped: ControlEvent<Void>
        let jerryButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showWanView: Driver<Void>
        let showMoanaView: Driver<Void>
        let showJerryView: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let showWanView = input.wanButtonTapped.asDriver()
        let showMoanaView = input.moanaButtonTapped.asDriver()
        let showJerryView = input.jerryButtonTapped.asDriver()

        return Output(showWanView: showWanView,
                      showMoanaView: showMoanaView,
                      showJerryView: showJerryView)
    }
}

