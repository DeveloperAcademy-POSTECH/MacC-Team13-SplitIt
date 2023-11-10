//
//  ExclItemInfoModalVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/30.
//

import RxSwift
import RxCocoa
import UIKit

class ExclItemInfoAddModalVM {
    
    var disposeBag = DisposeBag()
    
    let maxTextCount = 8
    
    let sections = BehaviorRelay<[ExclItemInfoModalSection]>(value: [])
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let title: Driver<String>
        let price: Driver<String>
        let titleTextFieldControlEvent: Observable<UIControl.Event>
        let priceTextFieldControlEvent: Observable<UIControl.Event>
        let cancelButtonTapped: ControlEvent<Void>
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let titleCount: Driver<String>
        let price: Driver<String>
        let titleTextFieldIsValid: BehaviorRelay<Bool>
        let priceIsLimited: Driver<Bool> // price의 합은 총액을 넘을 수 없음.
        let addButtonIsEnable: Driver<Bool>
        let titleTextFieldControlEvent: Driver<UIControl.Event>
        let priceTextFieldControlEvent: Driver<UIControl.Event>
        let cancelButtonTapped: Driver<Void>
        let addButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let title = input.title
        let titleTextFieldCount = BehaviorRelay<String>(value: "")
        let titleTextFieldIsValid = BehaviorRelay<Bool>(value: true)
        
        let priceResult = BehaviorRelay<Int>(value: 0)
        let numberFormatter = NumberFormatterHelper()
        
        let maxCurrency = 10000000
        let priceLimit = BehaviorRelay<Int>(value: 0)
        let priceIsLimited = input.price
            .map { price in
                let priceInt = numberFormatter.number(from: price)
                return priceInt ?? 0 >= priceLimit.value
            }
            .asDriver(onErrorJustReturn: false)
        
        let addButtonIsEnable: Driver<Bool>
        
        let titleTextFieldCountIsEmpty = input.title
            .map{ $0.count > 0 }
            .asDriver()
        
        let priceTextFieldCountIsEmpty = priceResult
            .asDriver()
            .map{ $0 != 0 }
            .asDriver()
        
        let exclMemberIsValid = BehaviorRelay<Bool>(value: false)
        sections
            .asDriver()
            .map { value in
                guard let section = value.first else { return false }
                return section.items.contains { $0.isTarget }
            }
            .drive(exclMemberIsValid)
            .disposed(by: disposeBag)
        
        let priceString = input.price
            .map { numberFormatter.number(from: $0) ?? 0 }
            .map { min($0, priceLimit.value) }
            .map { number in
                priceResult.accept(number)
                return number
            }
            .map {
                let price = numberFormatter.formattedString(from: $0)
                if price == "0" { return "" }
                return price
            }
            .asDriver(onErrorJustReturn: "0")
        
        let csInfoDriver = Driver.combineLatest(input.title, priceResult.asDriver())
        
        input.viewWillAppear
            .asDriver(onErrorJustReturn: false)
            .map{ _ in self.calculatePriceLimit() }
            .switchLatest()
            .drive(priceLimit)
            .disposed(by: disposeBag)
        
        input.addButtonTapped
            .asDriver()
            .withLatestFrom(csInfoDriver)
            .drive(onNext: { [weak self] title, price in
                guard let self = self else { return }
                let currentExclMember = sections.value.first!.items
                SplitRepository.share.createExclItem(name: title, price: price, exclMember: currentExclMember)
            })
            .disposed(by: disposeBag)
        
        title
            .map { title in
                let currentTextCount = title.count > self.maxTextCount ? title.count - 1 : title.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(titleTextFieldCount)
            .disposed(by: disposeBag)
        
        title
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(titleTextFieldIsValid)
            .disposed(by: disposeBag)
        
        addButtonIsEnable = Driver.combineLatest(titleTextFieldCountIsEmpty.asDriver(),
                                                  priceTextFieldCountIsEmpty.asDriver(),
                                                  exclMemberIsValid.asDriver())
            .map{ $0 && $1 && $2 }
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
        
        let priceTFControlEvent: Driver<UIControl.Event> = input.priceTextFieldControlEvent
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
            .map { $0.map { csMember -> ExclItemTable in
                let item = ExclItemTable(name: csMember.name, isTarget: false)
                return item
            }}
            .map { items -> [ExclItemInfoModalSection] in
                let section = ExclItemInfoModalSection(isActive: false, items: items)
                return [section]
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        return Output(titleCount: titleTextFieldCount.asDriver(),
                      price: priceString,
                      titleTextFieldIsValid: titleTextFieldIsValid,
                      priceIsLimited: priceIsLimited,
                      addButtonIsEnable: addButtonIsEnable,
                      titleTextFieldControlEvent: titleTFControlEvent,
                      priceTextFieldControlEvent: priceTFControlEvent,
                      cancelButtonTapped: input.cancelButtonTapped.asDriver(),
                      addButtonTapped: input.addButtonTapped.asDriver())
    }

    func calculatePriceLimit() -> Driver<Int> {
        
        var priceLimitValue = SplitRepository.share.csInfoArr.value.first!.totalAmount
        for item in SplitRepository.share.exclItemArr.value {
            priceLimitValue -= item.price
        }
        
        let priceLimitDriver = Driver<Int>.just(priceLimitValue)
        return priceLimitDriver
    }

}

