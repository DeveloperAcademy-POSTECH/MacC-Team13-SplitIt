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
        let confirmButtonTapped: ControlEvent<Void> // 다음 버튼
        let title: Driver<String> // TitleTextField의 text
        let totalAmount: Driver<String>
        let titleTextFieldControlEvent: Observable<UIControl.Event>
        let totalAmountTextFieldControlEvent: Observable<UIControl.Event>
    }
    
    struct Output {
        let titleString: Driver<String>
        let titleCount: Driver<String>
        let totalAmount: Driver<String>
        let titleTextFieldIsValid: BehaviorRelay<Bool>
        let titleTextFieldIsEnable: Driver<Bool>
        let totalAmountTextFieldIsValid: Driver<Bool>
        let totalAmountTextFieldMinIsValid: Driver<Bool>
        let confirmButtonIsEnable: Driver<Bool>
        let titleTextFieldControlEvent: Driver<UIControl.Event>
    }
    
    func transform(input: Input) -> Output {
        let inputTitle = input.title
        let saveCSInfo = input.confirmButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let titleTextFieldIsValid = BehaviorRelay<Bool>(value: true)
        
        let totalAmountResult = BehaviorRelay<Int>(value: 0)
        let totalAmountIsValid = BehaviorRelay<Bool>(value: true)
        let totalAmountMinIsValid = BehaviorRelay<Bool>(value: false)
        let numberFormatter = NumberFormatterHelper()

        let maxCurrency = 10000000
        
        let confirmButtonIsEnable: Driver<Bool>
        
        let title = BehaviorRelay(value: "")
        var totalAmount = Driver.merge(input.totalAmount)
        
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
            let titleDriver = Driver<String>.just(csinfo.title)
            let totalAmountDriver = Driver<String>.just("\(csinfo.totalAmount)")
            totalAmount = Driver.merge(input.totalAmount, totalAmountDriver)
            
            titleDriver
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
        
        input.totalAmount
            .map { Int($0) ?? 0 }
            .asDriver()
            .drive(totalAmountResult)
            .disposed(by: disposeBag)
        
        if let csinfo = self.csinfo {
            let totalAmountDriver = Driver<String>.just("\(csinfo.totalAmount)")
            totalAmount = Driver.merge(input.totalAmount, totalAmountDriver)
            
            totalAmount
                .asDriver()
                .map { Int($0) ?? 0 }
                .drive(totalAmountResult)
                .disposed(by: disposeBag)
        }
        
        let titleTextFieldCountIsEmpty = title
            .map{ $0.count > 0 }
            .asDriver(onErrorJustReturn: false)
        
        let totalAmountTextFieldCountIsEmpty = totalAmountResult
            .map { "\($0) "}
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map{ $0 != 0 }
            .asDriver(onErrorJustReturn: false)
        
        let totalAmountMinIsValidDriver = totalAmountResult
            .asDriver()
            .map(calculateMinTotalAmount)
        
        totalAmountMinIsValidDriver
            .drive(totalAmountMinIsValid)
            .disposed(by: disposeBag)
        
        let totalAmountString = totalAmount
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map { min($0, maxCurrency) }
            .map { number in
                totalAmountResult.accept(number)
                return number
            }
            .map {
                let totalAmount = numberFormatter.formattedString(from: $0)
                if totalAmount == "0" { return "" }
                return totalAmount
            }
            .asDriver(onErrorJustReturn: "0")
        
        let csInfoDriver = Driver.combineLatest(title.asDriver(), totalAmountResult.asDriver())
        
        saveCSInfo
            .asDriver()
            .withLatestFrom(csInfoDriver)
            .drive(onNext: { title, totalAmount in
                SplitRepository.share.editCSInfoTitle(title: title)
                SplitRepository.share.editCSInfoTotalAcount(totalAcount: totalAmount)
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
        
        confirmButtonIsEnable = Driver.combineLatest(titleTextFieldCountIsEmpty.asDriver(), totalAmountTextFieldCountIsEmpty.asDriver())
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
        
        return Output(titleString: title.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      totalAmount: totalAmountString,
                      titleTextFieldIsValid: titleTextFieldIsValid,
                      titleTextFieldIsEnable: titleTextFieldCountIsEmpty,
                      totalAmountTextFieldIsValid: totalAmountIsValid.asDriver(),
                      totalAmountTextFieldMinIsValid: totalAmountMinIsValidDriver,
                      confirmButtonIsEnable: confirmButtonIsEnable,
                      titleTextFieldControlEvent: titleTFControlEvent)
    }
    
    func calculateMinTotalAmount(_ value: Int) -> Bool {
        var minTotalAmount: Int = 0
        for item in SplitRepository.share.exclItemArr.value {
            minTotalAmount += item.price
        }
        let isValid = value >= minTotalAmount
        return isValid
    }
}

