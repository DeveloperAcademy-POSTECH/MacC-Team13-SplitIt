//
//  CSMemberVM.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/29.
//

import UIKit
import RxCocoa
import RxSwift

class CSMemberVM {
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTapped: ControlEvent<Void>
        let nextButtonTapped: ControlEvent<Void>
        let tableViewTapped: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let tableData: BehaviorRelay<[CSMember]>
        let showSearchView: Driver<Void>
        let showExclView: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let repo = SplitRepository.share
        
        let tableData = SplitRepository.share.csMemberArr
        let showExclView = input.nextButtonTapped
        
        let showSearchView: Driver<Void> = Driver.merge(
            input.searchButtonTapped.asDriver().map { _ in () },
            input.tableViewTapped.asDriver().map { _ in () }
        )
        
        input.nextButtonTapped
            .asDriver()
            .drive(onNext: {
                if !repo.isSmartSplit {
                    repo.updateDataToDB()
                }
            })
            .disposed(by: disposeBag)
        
        return Output(tableData: tableData, showSearchView: showSearchView, showExclView: showExclView)
    }
}
