//
//  EditCSMemberVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/11/04.
//

import UIKit
import RxCocoa
import RxSwift

class EditCSMemberVM {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
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
        let tableData = repo.csMemberArr
        let showSearchView = input.searchButtonTapped
        let showExclView = input.nextButtonTapped
        
        input.nextButtonTapped
            .asDriver()
            .drive(onNext: {
                //
                repo.editCSMemberAndExclMember()
                print("repo.exclMemberArr.value: \(repo.exclMemberArr.value)")
            })
            .disposed(by: disposeBag)
        
        return Output(tableData: tableData, showSearchView: showSearchView, showExclView: showExclView)
    }
}
