//
//  CSEditListVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class CSEditListVM {
    var disposeBag = DisposeBag()
    
    var csinfoIdx = ""
    
    let dataModel = SplitRepository.share
    private var data: Observable<CSInfo> {
        return dataModel.csInfoArr
            .asObservable()
            .observe(on: MainScheduler.instance)
            .take(1)
            .flatMap { csInfoArray in
                return csInfoArray.first.map(Observable.just) ?? Observable.empty()
            }
    }
    
    init(csinfoIdx: String = "652fe13e384fd0feba2561bf") {
        dataModel.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: csinfoIdx)
        self.csinfoIdx = csinfoIdx
    }
    
    var itemsObservable: BehaviorRelay<[ExclItem]> = {
        return SplitRepository.share.exclItemArr
    }()
    
    var titleObservable: Observable<String> {
        return data.map { $0.title }
    }
    
    var totalObservable: Observable<String> {
        return data.map { "\($0.totalAmount) rkw" }
    }

    var membersObservable: Observable<String> {
        return dataModel.csMemberArr
            .observe(on: MainScheduler.instance)
            .map {
                if $0.count == 0 {
                    return ""
                }
                if $0.count > 2 {
                    return "\($0[0].name), \( $0[1].name) 외 \($0.count - 2)인"
                }
                return "\($0[0].name), \($0[1].name)"
            }
            .asObservable()
    }
    
    struct Input {
        let titleBtnTap: ControlEvent<Void>
        let totalPriceTap: ControlEvent<Void>
        let memberTap: ControlEvent<Void>
        let exclItemTap: ControlEvent<IndexPath>
        let addExclItemTap: ControlEvent<UITapGestureRecognizer>
        let saveButtonTap: ControlEvent<Void>
        let delCSInfoTap: ControlEvent<UITapGestureRecognizer>
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let pushTitleEditVC: Observable<Void>
        let pushPriceEditVC: Observable<Void>
        let pushMemberEditVC: Observable<Void>
        let popVCinSaveBtn: Observable<Void>
        let pushExclItemEditVC: Observable<IndexPath>
        let pushExclItemAddVC: Observable<UITapGestureRecognizer>
        let popDelCSInfo: Observable<UITapGestureRecognizer>
//        let pushExclItemEditVC: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let title = input.titleBtnTap.asObservable()
        let price = input.totalPriceTap.asObservable()
        let member = input.memberTap.asObservable()
        let exclcell = input.exclItemTap.asObservable()
        let savebtn = input.saveButtonTap.asObservable()
        let delbtn = input.delCSInfoTap.asObservable()
        let addExcl = input.addExclItemTap.asObservable()
        
        input.viewWillAppear.asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                SplitRepository.share.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: self.csinfoIdx)
                self.itemsObservable
                    .accept(SplitRepository.share.exclItemArr.value)
            })
            .disposed(by: disposeBag)
        
        return Output(pushTitleEditVC: title,
                      pushPriceEditVC: price,
                      pushMemberEditVC: member,
                      popVCinSaveBtn: savebtn,
                      pushExclItemEditVC: exclcell,
                      pushExclItemAddVC: addExcl,
                      popDelCSInfo: delbtn)
    }
    
}


