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
    
    init() {
        dataModel.fetchSplitArrFromDBForHistoryView()
    }
    
    private var data: Observable<CSInfo> {
        return dataModel.csInfoArr
            .map {
                $0.first!
            }
            .asObservable()
    }
    
//    var itemsObservable: Observable<[ExclItem]> {
//        return data.map {  }
//    }
    
    var titleObservable: Observable<String> {
        return data.map { $0.title }
    }
    
    var totalObservable: Observable<String> {
        return data.map { "\($0.totalAmount)" }
    }

    var membersObservable: Observable<String> {
        return dataModel.csMemberArr.map{ $0.first! }
            .map{ $0.name }
            .asObservable()
    }
    
    struct Input {
        let titleBtnTap: ControlEvent<Void>
        let totalPriceTap: ControlEvent<Void>
        let memberTap: ControlEvent<Void>
//        let sectionHeaderSelectedSubject: ControlEvent<CSEditListHeader>
        let exclItemTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let pushTitleEditVC: Observable<Void>
        let pushPriceEditVC: Observable<Void>
        let pushMemberEditVC: Observable<Void>
//        let sectionHeaderSelectedObservable: Observable<CSEditListHeader>
        let pushExclItemEditVC: Observable<IndexPath>
//        let pushExclItemEditVC: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let title = input.titleBtnTap.asObservable()
        let price = input.totalPriceTap.asObservable()
        let member = input.memberTap.asObservable()
        let exclcell = input.exclItemTap.asObservable()
        
        return Output(pushTitleEditVC: title, pushPriceEditVC: price, pushMemberEditVC: member, pushExclItemEditVC: exclcell)
    }
    
}

