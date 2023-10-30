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
    
    init(splitIdx: String = "653e1192001cb7e6e7996ad3") {
        dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: splitIdx)
        self.splitIdx = splitIdx
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
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
    }
    
    func transform(input: Input) -> Output {
        let title = input.title
        let showNextView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        let textFieldCountIsEmpty: Driver<Bool>
        let splitTitle = split.map { $0.title }
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: "653e1192001cb7e6e7996ad3")
                print("패치 됌 = \(SplitRepository.share.csInfoArr.value.count)")
            })
            .disposed(by: disposeBag)

        showNextView
            .asDriver()
            .withLatestFrom(input.title)
            .drive(onNext: {
//                SplitRepository.share.inputCSInfoWithTitle(title: $0)
                print("\($0)")
            })
            .disposed(by: disposeBag)
        
        title
            .map { title in
                let currentTextCount = title.count > self.maxTextCount ? title.count - 1 : title.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(textFieldCount)
            .disposed(by: disposeBag)
        
        title
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(textFieldIsValid)
            .disposed(by: disposeBag)
        
        textFieldCountIsEmpty = input.title
            .map{ $0.count > 0 }
            .asDriver()
        
        return Output(pushNextView: showNextView.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver(),
                      textFieldIsEmpty: textFieldCountIsEmpty,
                      splitTitle: splitTitle)
    }

}

