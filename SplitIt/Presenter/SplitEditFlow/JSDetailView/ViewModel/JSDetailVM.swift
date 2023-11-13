//
//  JSDetailVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/30.
//

import RxSwift
import Foundation
import RxCocoa
import UIKit

final class JSDetailVM {
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

    init() {
        let arrSplit = SplitRepository.share.splitArr.value
        if let firstSplit = arrSplit.first {
            self.splitIdx = firstSplit.splitIdx
            self.dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: splitIdx)
        } else {
            splitIdx = ""
        }
    }
    
    struct Input {
        let viewDidLoad: Observable<Bool>
        let csEditTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let pushCSEditView: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let csinfoIndex = input.csEditTapped.asDriver()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: splitIdx)
            })
            .disposed(by: disposeBag)
        
        let pushEditView: Driver<String> = csinfoIndex
            .withLatestFrom(self.csinfoList) { indexPath, data in
                return data[indexPath.row].csInfoIdx
            }
        
        return Output(pushCSEditView: pushEditView)
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
