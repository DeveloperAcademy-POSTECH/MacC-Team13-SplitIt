//
//  EditCSListVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/30.
//

import RxSwift
import Foundation
import RxCocoa
import UIKit

final class EditCSListVM {
    var disposeBag = DisposeBag()
    
    let maxTextCount = 8
    let splitIdx: String

    init() {
        let arrSplit = SplitRepository.share.splitArr.value
        if let firstSplit = arrSplit.first {
            self.splitIdx = firstSplit.splitIdx
        } else {
            splitIdx = ""
        }
    }
    
    struct Input {
        let viewDidAppear: Observable<Bool>
        let csEditTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let csInfoList: Driver<[CSInfo]>
        let memberCount: Driver<[Int]>
        let exclItemCount: Driver<[Int]>
        let pushCSEditView: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let dataModel = SplitRepository.share
        let csinfoIndex = input.csEditTapped
        let csinfoList: BehaviorRelay<[CSInfo]> = dataModel.csInfoArr
        let exclList: BehaviorRelay<[ExclItem]> = dataModel.exclItemArr
        let csMemberList: BehaviorRelay<[CSMember]> = dataModel.csMemberArr
        
        input.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
//                dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: self.splitIdx)
            })
            .disposed(by: disposeBag)
        
        let pushEditView = csinfoIndex
            .withLatestFrom(csinfoList) { indexPath, data in
                return data[indexPath.row].csInfoIdx
            }
        
        let memberCount = csinfoList.flatMapLatest { infoList in
            return csMemberList.map { members in
                infoList.map { info in
                    members.filter { member in
                        member.csInfoIdx == info.csInfoIdx
                    }.count
                }
            }
        }
        
        let exclItemCount = csinfoList.flatMapLatest { infoList in
            return exclList.map { members in
                infoList.map { info in
                    members.filter { member in
                        member.csInfoIdx == info.csInfoIdx
                    }.count
                }
            }
        }
        
        return Output(
            csInfoList: csinfoList.asDriver(),
            memberCount: memberCount.asDriver(onErrorJustReturn: []),
            exclItemCount: exclItemCount.asDriver(onErrorJustReturn: []),
            pushCSEditView: pushEditView.asDriver(onErrorJustReturn: ""))
    }
    
}
