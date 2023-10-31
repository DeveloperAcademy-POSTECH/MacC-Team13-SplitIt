//
//  ExclItemInputVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/29.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemInputVM {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let exclItemAddButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showResultView: Driver<Void>
        let exclItemsRelay: BehaviorRelay<[ExclItemInfo]>
        let nextButtonIsEnable: Driver<Bool>
        let showExclItemInfoModal: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let showResultView = input.nextButtonTapped
        let showExclItemInfoModal = input.exclItemAddButtonTapped
        let nextButtonIsEnable: Driver<Bool>

        let exclItemRepository = SplitRepository.share.exclItemArr
        let exclMemberRepository = SplitRepository.share.exclMemberArr
        let exclItemsRelay = BehaviorRelay<[ExclItemInfo]>(value: [
            ExclItemInfo(exclItem: ExclItem(csInfoIdx: "", name: "", price: 0), items: [])
        ])
        
        Observable.combineLatest(exclItemRepository, exclMemberRepository)
            .map{ (exclItems, exclMembers) -> [ExclItemInfo] in
                let exclItemInfos = exclItems.map { exclItem in
                    let targetMember = exclMembers.filter{ $0.exclItemIdx == exclItem.exclItemIdx }
                    let exclItemInfo = ExclItemInfo(exclItem: exclItem, items: targetMember)
                    return exclItemInfo
                }
                return exclItemInfos
            }
            .asDriver(onErrorJustReturn: [])
            .drive(exclItemsRelay)
            .disposed(by: disposeBag)

        nextButtonIsEnable = exclItemsRelay
            .map{ $0.count > 0 }
            .asDriver(onErrorJustReturn: false)
        
        return Output(showResultView: showResultView.asDriver(),
                      exclItemsRelay: exclItemsRelay,
                      nextButtonIsEnable: nextButtonIsEnable,
                      showExclItemInfoModal: showExclItemInfoModal.asDriver())
    }

}

