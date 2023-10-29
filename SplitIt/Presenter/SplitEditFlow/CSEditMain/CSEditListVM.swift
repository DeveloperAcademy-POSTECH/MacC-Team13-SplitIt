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
    
    var itemsObservable: BehaviorRelay<[ExclItem]> {
        return SplitRepository.share.exclItemArr
    }
    
    init(csinfoIdx: String = "652fe13e384fd0feba2561bf") {
        dataModel.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: csinfoIdx)
        self.csinfoIdx = csinfoIdx
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
        let titleOB: Driver<String>
        let totalAmOb: Driver<String>
        let membersOb: Driver<String>
        let pushTitleEditVC: Driver<Void>
        let pushPriceEditVC: Driver<Void>
        let pushMemberEditVC: Driver<Void>
        let popVCinSaveBtn: Driver<Void>
        let pushExclItemEditVC: Driver<IndexPath>
        let pushExclItemAddVC: Driver<UITapGestureRecognizer>
        let popDelCSInfo: Driver<UITapGestureRecognizer>
    }
    
    func transform(input: Input) -> Output {
        let title = input.titleBtnTap.asDriver()
        let price = input.totalPriceTap.asDriver()
        let member = input.memberTap.asDriver()
        let exclcell = input.exclItemTap.asDriver()
        let savebtn = input.saveButtonTap.asDriver()
        let delbtn = input.delCSInfoTap.asDriver()
        let addExcl = input.addExclItemTap.asDriver()
        
        input.viewWillAppear.asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                SplitRepository.share.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: self.csinfoIdx)
                self.itemsObservable
                    .accept(SplitRepository.share.exclItemArr.value)
            })
            .disposed(by: disposeBag)
        
        let titleob = data.map { $0.title }.asDriver(onErrorJustReturn: "")
        let totalAmob = data.map { "\($0.totalAmount) rkw" }.asDriver(onErrorJustReturn: "")
        let membersob = dataModel.csMemberArr
            .map {
                if $0.count == 0 {
                    return ""
                }
                if $0.count > 2 {
                    return "\($0[0].name), \( $0[1].name) 외 \($0.count - 2)인"
                }
                return "\($0[0].name), \($0[1].name)"
            }.asDriver(onErrorJustReturn: "")
        
        return Output(titleOB: titleob,
                      totalAmOb: totalAmob,
                      membersOb: membersob,
                      pushTitleEditVC: title,
                      pushPriceEditVC: price,
                      pushMemberEditVC: member,
                      popVCinSaveBtn: savebtn,
                      pushExclItemEditVC: exclcell,
                      pushExclItemAddVC: addExcl,
                      popDelCSInfo: delbtn)
    }
    
}


