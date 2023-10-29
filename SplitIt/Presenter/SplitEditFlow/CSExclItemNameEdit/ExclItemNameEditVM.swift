//
//  File.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/21.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemNameEditVM {
    
    var disposeBag = DisposeBag()
    var indexPath: IndexPath?
    
    let maxTextCount = 8
    
    init() {
        
    }
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let name: Driver<String>
    }
    
    struct Output {
        let showExclItemPriceView: Driver<Void>
        let nameCount: Driver<String>
        let textFieldIsValid: Driver<Bool>
        let exclTitle: Observable<String>
        let textfieldEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let name = input.name
        let showExclItemPriceView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        
        name
            .map { text in
                let currentTextCount = text.count > self.maxTextCount ? text.count - 1 : text.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(textFieldCount)
            .disposed(by: disposeBag)
        
        name
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(textFieldIsValid)
            .disposed(by: disposeBag)
        
        let textFieldCountIsEmpty = input.name
            .map{ $0.count > 0 }
            .asDriver()
        
        if let indexPath = indexPath {
            let data = SplitRepository.share.exclItemArr.map { $0[indexPath.row]   }
            var exclIdx = ""
            let exclName = data.map { $0.name }.asObservable()
            
            data.map { $0.exclItemIdx }.subscribe { st in
                exclIdx = st
            }.disposed(by: disposeBag)
            
            showExclItemPriceView
                .asDriver()
                .withLatestFrom(input.name)
                .drive(onNext: {
                    if exclIdx != "" {
                        SplitRepository.share.editExclItemName(exclItemIdx: exclIdx, name: $0)
                    }
                })
                .disposed(by: disposeBag)
            
            return Output(showExclItemPriceView: showExclItemPriceView.asDriver(),
                          nameCount: textFieldCount.asDriver(),
                          textFieldIsValid: textFieldIsValid.asDriver(),
                          exclTitle: exclName,
                          textfieldEmpty: textFieldCountIsEmpty)

        } else {
            name.drive(onNext: {             SplitRepository.share.createExclItemWithName(name: $0)})
                .disposed(by: disposeBag)
            return Output(showExclItemPriceView: showExclItemPriceView.asDriver(),
                          nameCount: textFieldCount.asDriver(),
                          textFieldIsValid: textFieldIsValid.asDriver(),
                          exclTitle: Observable.just(""),
                          textfieldEmpty: textFieldCountIsEmpty)
        }
        
    }

}

