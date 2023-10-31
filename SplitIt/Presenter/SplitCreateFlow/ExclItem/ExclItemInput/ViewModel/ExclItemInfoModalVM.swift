//
//  ExclItemInfoModalVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/30.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemInfoModalVM {
    
    var disposeBag = DisposeBag()
    
    let maxTextCount = 8
    
    let sections = BehaviorRelay<[ExclItemInfoModalSection]>(value: [])
    let exclMembers = BehaviorRelay<[ExclMember]>(value: [])
    let exclMemberIsActive = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let nextButtonTapped: ControlEvent<Void>
        let title: Driver<String>
        let totalAmount: Driver<String>
        let titleTextFieldControlEvent: Observable<UIControl.Event>
        let totalAmountTextFieldControlEvent: Observable<UIControl.Event>
    }
    
    struct Output {
        let addExclItem: Driver<Void>
        let titleCount: Driver<String>
        let totalAmount: Driver<String>
        let textFieldIsValid: Driver<Bool>
        let titleTextFieldIsEnable: Driver<Bool>
        let totalAmountTextFieldIsEnable: Driver<Bool>
        let nextButtonIsEnable: Driver<Bool>
        let titleTextFieldControlEvent: Driver<UIControl.Event>
        let totalAmountTextFieldControlEvent: Driver<UIControl.Event>
    }
    
    func transform(input: Input) -> Output {
        let title = input.title
        let showCSTotalAmountView = input.nextButtonTapped
        let textFieldCount = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        
        let totalAmountResult = BehaviorRelay<Int>(value: 0)
        let numberFormatter = NumberFormatterHelper()

        let maxCurrency = 10000000
        
        let nextButtonIsEnable: Driver<Bool>
        
        let titleTextFieldCountIsEmpty = input.title
            .map{ $0.count > 0 }
            .asDriver()
        
        let totalAmountTextFieldCountIsEmpty = input.totalAmount
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map{ $0 != 0 }
            .asDriver()
        
        let totalAmountString = input.totalAmount
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map { min($0, maxCurrency) }
            .map { number in
                totalAmountResult.accept(number)
                return number
            }
            .map { numberFormatter.formattedString(from: $0) }
            .asDriver(onErrorJustReturn: "0")
        
        let csInfoDriver = Driver.combineLatest(input.title, input.totalAmount)
        
        showCSTotalAmountView
            .asDriver()
            .withLatestFrom(csInfoDriver)
            .drive(onNext: { title, totalAmount in
                let totalAmountInt = numberFormatter.number(from: totalAmount)
                SplitRepository.share.inputCSInfoWithTitle(title: title)
                SplitRepository.share.inputCSInfoWithTotalAmount(totalAmount: totalAmountInt ?? 0)
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
        
        let totalAmountTFControlEvent: Driver<UIControl.Event> = input.totalAmountTextFieldControlEvent
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
        
        let currentMembers = SplitRepository.share.csMemberArr
        currentMembers
            .map { csMembers -> [ExclMember] in
                let newExclMembers = csMembers.map{ return ExclMember(exclItemIdx: "", name: $0.name) }
                return newExclMembers
            }
            .bind(to: exclMembers)
            .disposed(by: disposeBag)
         
        exclMembers
            .map { $0.map { exclMember -> ExclItemTable in
                let item = ExclItemTable(name: exclMember.name, isTarget: false)
                return item
            }}
            .map { items -> [ExclItemInfoModalSection] in
                let section = ExclItemInfoModalSection(isActive: false, items: items)
                print(section)
                return [section]
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        return Output(addExclItem: showCSTotalAmountView.asDriver(),
                      titleCount: textFieldCount.asDriver(),
                      totalAmount: totalAmountString,
                      textFieldIsValid: textFieldIsValid.asDriver(),
                      titleTextFieldIsEnable: titleTextFieldCountIsEmpty,
                      totalAmountTextFieldIsEnable: totalAmountTextFieldCountIsEmpty,
                      nextButtonIsEnable: nextButtonIsEnable,
                      titleTextFieldControlEvent: titleTFControlEvent,
                      totalAmountTextFieldControlEvent: totalAmountTFControlEvent)
    }

}

