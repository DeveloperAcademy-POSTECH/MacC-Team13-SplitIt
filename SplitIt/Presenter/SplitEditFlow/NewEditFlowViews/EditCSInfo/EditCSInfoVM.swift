//
//  EditCSInfoVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/11/03.
//

import RxSwift
import RxCocoa
import UIKit

class EditCSInfoVM {
    
    var disposeBag = DisposeBag()
    
    let maxTextCount = 8
    
    let csinfo = SplitRepository.share.csInfoArr.value.first
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void> // 다음 버튼
        let title: Driver<String> // TitleTextField의 text
        let totalAmount: Driver<String>
        let titleTextFieldControlEvent: Observable<UIControl.Event>
        let totalAmountTextFieldControlEvent: Observable<UIControl.Event>
    }
    
    struct Output {
        let showCSMemberView: Driver<Void>
        let titleString: Driver<String>
        let titleCount: Driver<String>
        let totalAmount: Driver<String>
        let titleTextFieldIsValid: BehaviorRelay<Bool>
        let titleTextFieldIsEnable: Driver<Bool>
        let totalAmountTextFieldIsValid: Driver<Bool>
        let nextButtonIsEnable: Driver<Bool>
        let titleTextFieldControlEvent: Driver<UIControl.Event>
    }
    
    func transform(input: Input) -> Output {
        let inputTitle = input.title
        let showCSTotalAmountView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let titleTextFieldIsValid = BehaviorRelay<Bool>(value: true)
        
        let totalAmountResult = BehaviorRelay<Int>(value: 0)
        let totalAmountIsValid = BehaviorRelay<Bool>(value: true)
        let numberFormatter = NumberFormatterHelper()

        let maxCurrency = 10000000
        
        let nextButtonIsEnable: Driver<Bool>
        
        let title = BehaviorRelay(value: "")
        var price = Driver.merge(input.totalAmount)
        
        inputTitle
            .map { [weak self] text -> String in
                guard let self = self else { return text }
                if text.count > self.maxTextCount {
                    let index = text.index(text.startIndex, offsetBy: self.maxTextCount)
                    return String(text[..<index])
                }
                return text
            }
            .drive(title)
            .disposed(by: disposeBag)
        
        if let csinfo = self.csinfo {
            let tittttle = Driver<String>.just(csinfo.title)
            let prrrice = Driver<String>.just("\(csinfo.totalAmount)")
            price = Driver.merge(input.totalAmount, prrrice)
            
            tittttle
                .map { [weak self] text -> String in
                    guard let self = self else { return "\(text)" }
                    if text.count > self.maxTextCount {
                        let index = text.index(text.startIndex, offsetBy: self.maxTextCount)
                        return String(text[..<index])
                    }
                    return text
                }
                .drive(title)
                .disposed(by: disposeBag)
        }
        
        let titleTextFieldCountIsEmpty = title
            .map{ $0.count > 0 }
            .asDriver(onErrorJustReturn: false)
        
        let totalAmountTextFieldCountIsEmpty = input.totalAmount
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map{ $0 != 0 }
            .asDriver()
        
        let totalAmountString = price
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map { min($0, maxCurrency) }
            .map { number in
                totalAmountResult.accept(number)
                return number
            }
            .map { numberFormatter.formattedString(from: $0) }
            .asDriver(onErrorJustReturn: "0")
        
        let csInfoDriver = Driver.combineLatest(title.asDriver(), input.totalAmount)
        
        showCSTotalAmountView
            .asDriver()
            .withLatestFrom(csInfoDriver)
            .drive(onNext: { title, totalAmount in
                let totalAmountInt = numberFormatter.number(from: totalAmount)
                SplitRepository.share.editCSInfoTitle(title: title)
                SplitRepository.share.editCSInfoTotalAcount(totalAcount: totalAmountInt ?? 0)
            })
            .disposed(by: disposeBag)
        
        title.asDriver()
            .map { title in
                let currentTextCount = title.count > self.maxTextCount ? title.count - 1 : title.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(textFieldCount)
            .disposed(by: disposeBag)
        
        title.asDriver()
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(titleTextFieldIsValid)
            .disposed(by: disposeBag)
        
        nextButtonIsEnable = Driver.combineLatest(titleTextFieldCountIsEmpty.asDriver(), totalAmountTextFieldCountIsEmpty.asDriver())
            .map{ $0 && $1 }
            .asDriver()
        
        let titleTFControlEvent: Driver<UIControl.Event> = input.titleTextFieldControlEvent
            .map { event -> UIControl.Event in
                switch event {
                case .editingDidBegin:
                    return UIControl.Event.editingDidBegin
                case .editingDidEnd:
                    return UIControl.Event.editingDidEnd
                default:
                    return UIControl.Event()
                }
            }
            .asDriver(onErrorJustReturn: UIControl.Event())
        
        totalAmountResult
            .asDriver()
            .map { $0 < maxCurrency }
            .drive(totalAmountIsValid)
            .disposed(by: disposeBag)
        
        return Output(showCSMemberView: showCSTotalAmountView.asDriver(),
                      titleString: title.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      totalAmount: totalAmountString,
                      titleTextFieldIsValid: titleTextFieldIsValid,
                      titleTextFieldIsEnable: titleTextFieldCountIsEmpty,
                      totalAmountTextFieldIsValid: totalAmountIsValid.asDriver(),
                      nextButtonIsEnable: nextButtonIsEnable,
                      titleTextFieldControlEvent: titleTFControlEvent)
    }

}

