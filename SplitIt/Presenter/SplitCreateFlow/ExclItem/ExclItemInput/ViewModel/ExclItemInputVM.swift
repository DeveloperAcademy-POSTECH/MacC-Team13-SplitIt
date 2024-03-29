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
    var createService: CreateServiceType
    var disposeBag = DisposeBag()
    
    init(createService: CreateServiceType) {
        self.createService = createService
    }
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let exclItemAddButtonTapped: ControlEvent<Void>
        let exitButtonTapped: ControlEvent<Void>
        let backButtonTapped: ControlEvent<Void>
        let swipeBack: ControlEvent<UIScreenEdgePanGestureRecognizer>
    }
    
    struct Output {
        let showResultView: Driver<Void>
        let exclItemsRelay: BehaviorRelay<[ExclItemInfo]>
        let nextButtonIsEnable: Driver<Bool>
        let showExclItemInfoModal: Driver<Void>
        let showEmptyView: Driver<Bool>
        let showExitAlert: Driver<Void>
        let showBackAlert: Driver<Void>
        let backToPreVC: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let showResultView = input.nextButtonTapped
        let showExclItemInfoModal = input.exclItemAddButtonTapped
        let nextButtonIsEnable: Driver<Bool>
        let showEmptyView = BehaviorRelay<Bool>(value: false)

        let exclItemRepository = createService.exclItemRelay
        let exclMemberRepository = createService.exclMemberRelay
        let exclItemsRelay = BehaviorRelay<[ExclItemInfo]>(value: [
            ExclItemInfo(exclItem: ExclItem(name: "", price: 0, csInfoIdx: ""), items: [])
        ])
        
        let showBackAlert = PublishRelay<Void>()
        let backToPreVC = PublishRelay<Void>()
        
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
        
        let backAction = Driver.merge(input.backButtonTapped.asDriver(),
                         input.swipeBack.map{ _ in }.asDriver(onErrorJustReturn: ()))
        
        backAction
            .withLatestFrom(exclItemsRelay.asDriver())
            .map { exclItems in
                return exclItems.count > 0
            }
            .drive(onNext: { shouldShowAlert in
                if shouldShowAlert {
                    showBackAlert.accept(())
                } else {
                    backToPreVC.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        return Output(showResultView: showResultView.asDriver(),
                      exclItemsRelay: exclItemsRelay,
                      nextButtonIsEnable: nextButtonIsEnable,
                      showExclItemInfoModal: showExclItemInfoModal.asDriver(),
                      showEmptyView: showEmptyView.asDriver(onErrorJustReturn: false),
                      showExitAlert: input.exitButtonTapped.asDriver(),
                      showBackAlert: showBackAlert.asDriver(onErrorJustReturn: ()),
                      backToPreVC: backToPreVC.asDriver(onErrorJustReturn: ()))
    }
}

