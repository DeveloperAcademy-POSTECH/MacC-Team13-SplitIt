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
        let tableData = SplitRepository.share.csMemberArr
        let showSearchView = input.searchButtonTapped
        let showExclView = input.nextButtonTapped
        
        return Output(tableData: tableData, showSearchView: showSearchView, showExclView: showExclView)
    }
}
