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
    }
    
    struct Output {
        let tableData: BehaviorRelay<[CSMember]>
        let showSearchView: ControlEvent<Void>
        let showExclView: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let repo = SplitRepository.share
        
        let tableData = SplitRepository.share.csMemberArr
        let showSearchView = input.searchButtonTapped
        let showExclView = input.nextButtonTapped
        
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
