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
        let nextButtonTapped: ControlEvent<Void>
        let title: Driver<String>
        let csEditTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let pushNextView: Driver<Void>
        let titleCount: Driver<String>
        let textFieldIsValid: Driver<Bool>
        let textFieldIsEmpty: Driver<Bool>
        let splitTitle: Driver<String>
        let pushCSEditView: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let title = input.title
        let showNextView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        let textFieldCountIsEmpty: Driver<Bool>
        let displayString = BehaviorRelay(value: "")
        let splitTitle = split.map { $0.title }
        let csinfoIndex = input.csEditTapped.asDriver()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: splitIdx)
            })
            .disposed(by: disposeBag)
        
        splitTitle
            .map { [weak self] text -> String in
                guard let self = self else { return text }
                if text.count > self.maxTextCount {
                    let index = text.index(text.startIndex, offsetBy: self.maxTextCount)
                    return String(text[..<index])
                }
                return text
            }
            .drive(displayString)
            .disposed(by: disposeBag)
        
        title
            .map { [weak self] text -> String in
                guard let self = self else { return text }
                if text.count > self.maxTextCount {
                    let index = text.index(text.startIndex, offsetBy: self.maxTextCount)
                    return String(text[..<index])
                }
                return text
            }
            .drive(displayString)
            .disposed(by: disposeBag)
        
        showNextView
            .withLatestFrom(displayString)
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: {
                SplitRepository.share.editSplitTitle(title: $0)
            })
            .disposed(by: disposeBag)
        
        displayString.asDriver()
            .map { title in
                let currentTextCount = title.count > self.maxTextCount ? title.count - 1 : title.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(textFieldCount)
            .disposed(by: disposeBag)
        
        displayString.asDriver()
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(textFieldIsValid)
            .disposed(by: disposeBag)
    
        textFieldCountIsEmpty = displayString.asDriver()
            .map{ $0.count > 0 }
            .asDriver()
        
        let pushEditView: Driver<String> = csinfoIndex
            .withLatestFrom(self.csinfoList) { indexPath, data in
                // MARK: 수정하기로 들어가도 SplitTitle이 저장되도록 수정
                SplitRepository.share.editSplitTitle(title: displayString.value)
                return data[indexPath.row].csInfoIdx
            }
        
        return Output(pushNextView: showNextView.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver(),
                      textFieldIsEmpty: textFieldCountIsEmpty,
                      splitTitle: displayString.asDriver(),
                      pushCSEditView: pushEditView)
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
