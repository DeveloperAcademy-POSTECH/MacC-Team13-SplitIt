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
    
    let dataModel = SplitRepository.share
    private var data: Observable<CSInfo> {
        return dataModel.csInfoArr
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .take(1)
            .flatMap { csInfoArray in
                print(csInfoArray)
                return csInfoArray.first.map(Observable.just) ?? Observable.empty()
            }
    }
    
    init(csinfoIdx: String = "652fe13e384fd0feba2561bf") {
        dataModel.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: csinfoIdx)
    }
    
    var itemsObservable: Observable<[ExclItem]> {
        return dataModel.exclItemArr.asObservable()
    }
    
    var titleObservable: Observable<String> {
        return data.map { $0.title }
    }
    
    var totalObservable: Observable<String> {
        return data.map { "\($0.totalAmount) rkw" }
    }

    var membersObservable: Observable<String> {
        return dataModel.csMemberArr
            .observe(on: MainScheduler.asyncInstance)
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
        
        return Output(pushTitleEditVC: title,
                      pushPriceEditVC: price,
                      pushMemberEditVC: member,
                      popVCinSaveBtn: savebtn,
                      pushExclItemEditVC: exclcell,
                      pushExclItemAddVC: addExcl,
                      popDelCSInfo: delbtn)
    }
    
}


