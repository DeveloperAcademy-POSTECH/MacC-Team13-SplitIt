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
    
    private let exclItemIsAdded = NotificationCenter.default.rx.notification(.exclItemIsAdded)
    private let exclItemIsEdited = NotificationCenter.default.rx.notification(.exclItemIsEdited)
    private let exclItemIsDeleted = NotificationCenter.default.rx.notification(.exclItemIsDeleted)
    
    lazy var exclItemNotification = Observable.merge([exclItemIsAdded, exclItemIsEdited, exclItemIsDeleted])

    struct Input {
        let backToReceiptTapped: ControlEvent<Void>
        let exclItemAddButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showSplitShareView: Driver<Void>
        let exclItemsRelay: BehaviorRelay<[ExclItemInfo]>
        let showExclItemInfoModal: Driver<Void>
        let showEmptyView: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let showSplitShareView = input.backToReceiptTapped
        let showExclItemInfoModal = input.exclItemAddButtonTapped
        let showEmptyView = BehaviorRelay<Bool>(value: false)

        let exclItemRepository = SplitRepository.share.exclItemArr
        let exclMemberRepository = SplitRepository.share.exclMemberArr
        let exclItemsRelay = BehaviorRelay<[ExclItemInfo]>(value: [])
        
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
        
        exclItemNotification
            .subscribe(onNext: { _ in
                SplitRepository.share.updateDataToDB()
            })
            .disposed(by: disposeBag)

        return Output(showSplitShareView: showSplitShareView.asDriver(),
                      exclItemsRelay: exclItemsRelay,
                      showExclItemInfoModal: showExclItemInfoModal.asDriver(),
                      showEmptyView: showEmptyView.asDriver(onErrorJustReturn: false))
    }

}

