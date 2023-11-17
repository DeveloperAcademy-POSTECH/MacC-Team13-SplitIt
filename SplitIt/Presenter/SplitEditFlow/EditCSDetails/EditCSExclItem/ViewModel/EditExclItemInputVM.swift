//
//  EditExclItemInputVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/11/04.
//

import RxSwift
import RxCocoa
import UIKit

class EditExclItemInputVM {
    
    var disposeBag = DisposeBag()
    var isEdited = BehaviorRelay(value: false)
    
    struct Input {
        let viewDidDisAppear: Observable<Bool>
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let exclItemAddButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showResultView: Driver<Void>
        let exclItemsRelay: BehaviorRelay<[ExclItemInfo]>
        let nextButtonIsEnable: Driver<Bool>
        let showExclItemInfoModal: Driver<Void>
        let showEmptyView: Driver<Bool>
        let showToastMessage: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let showResultView = input.nextButtonTapped
        let showExclItemInfoModal = input.exclItemAddButtonTapped
        let nextButtonIsEnable: Driver<Bool>
        let showEmptyView = BehaviorRelay<Bool>(value: false)

        let exclItemRepository = SplitRepository.share.exclItemArr
        let exclMemberRepository = SplitRepository.share.exclMemberArr
        let exclItemsRelay = BehaviorRelay<[ExclItemInfo]>(value: [])
        
        let showToastMessage = BehaviorRelay<Bool>(value: false)
        
//        exclItemRepository
        
//        input.viewDidDisAppear
//            .asDriver(onErrorJustReturn: false)
//            .drive(onNext: { _ in
//                SplitRepository.share.deleteCurrentExclItemAndExclMember()
//            })
//            .disposed(by: disposeBag)
        
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
        
        exclItemsRelay
            .map{$0.count == 0}
            .asDriver(onErrorJustReturn: false)
            .drive(showEmptyView)
            .disposed(by: disposeBag)

        nextButtonIsEnable = exclItemsRelay
            .map{ $0.count > 0 }
            .asDriver(onErrorJustReturn: false)
        
        return Output(showResultView: showResultView.asDriver(),
                      exclItemsRelay: exclItemsRelay,
                      nextButtonIsEnable: nextButtonIsEnable,
                      showExclItemInfoModal: showExclItemInfoModal.asDriver(),
                      showEmptyView: showEmptyView.asDriver(onErrorJustReturn: false),
                      showToastMessage: showToastMessage)
    }

}

