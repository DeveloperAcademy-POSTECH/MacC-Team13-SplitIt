//
//  EditCSListVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/31.
//

import RxSwift
import Foundation
import RxCocoa
import UIKit

final class EditCSListVM {
    var disposeBag = DisposeBag()
    
    let dataModel = SplitRepository.share
    let maxTextCount = 8
    let splitIdx: String
    
    var split: Driver<Split> {
        dataModel.splitArr
            .asDriver()
            .flatMap { splitList -> Driver<Split> in
                if let firstSplit = splitList.first {
                    return Driver.just(firstSplit)
                } else {
                    return Driver.empty()
                }
            }
    }
    
    var csinfoList: Driver<[CSInfo]> {
        dataModel.csInfoArr.asDriver()
    }
    
    var exclList: Driver<[ExclItem]> {
        dataModel.exclItemArr.asDriver()
    }
    
    var csMemberList: Driver<[CSMember]> {
        dataModel.csMemberArr.asDriver()
    }
    
    init(splitIdx: String = "653e1192001cb7e6e7996ad3") {
        dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: splitIdx)
        self.splitIdx = splitIdx
    }
    
    struct Input {
        let viewDidLoad: Observable<Bool>
        let nextButtonTapped: ControlEvent<Void>
        let csEditTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let pushNextView: Driver<Void>
        let csTitle: Driver<String>
        let pushCSEditView: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
    func memberCount() -> [Int] {
        let countsDriver: Driver<[Int]> = csinfoList.flatMapLatest { [weak self] infoList in
            guard let self = self else { return Driver.empty() }
            return self.csMemberList.map { members in
                infoList.map { info in
                    members.filter { member in
                        member.csInfoIdx == info.csInfoIdx
                    }.count
                }
            }
        }
        
        var count: [Int] = []
        countsDriver.drive {
            count = $0
        }
        .disposed(by: disposeBag)
        
        return count
    }
    
    func exclItemCount() -> [Int] {
        let countsDriver: Driver<[Int]> = csinfoList.flatMapLatest { [weak self] infoList in
            guard let self = self else { return Driver.empty() }
            return exclList.map { members in
                infoList.map { info in
                    members.filter { member in
                        member.csInfoIdx == info.csInfoIdx
                    }.count
                }
            }
        }
        var count: [Int] = []
        countsDriver.drive {
            count = $0
        }
        .disposed(by: disposeBag)
        
        return count
    }

}
