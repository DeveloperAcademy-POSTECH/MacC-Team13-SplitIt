//
//  ExclItemInfoEditModalVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/11/01.
//

import RxSwift
import RxCocoa
import UIKit

final class ExclItemInfoEditModalVM {
    
    private var disposeBag = DisposeBag()
    private let exclItemIdx: String
    private let createService: CreateServiceType
    let maxTextCount = 8
    
    init(createService: CreateServiceType,
         exclItemIdx: String
    ) {
        self.createService = createService
        self.exclItemIdx = exclItemIdx
    }
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let viewDidLoad: Driver<Void>
        let title: Driver<String>
        let price: Driver<String>
        let titleTextFieldControlEvent: Observable<UIControl.Event>
        let priceTextFieldControlEvent: Observable<UIControl.Event>
        let cancelButtonTapped: ControlEvent<Void>
        let editButtonTapped: ControlEvent<Void>
        let deleteButtonTapped: ControlEvent<Void>
        let isActiveRelay: BehaviorRelay<Bool>
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
        let editButtonTapped: Driver<Void>
        let showAlertVC: Driver<(String, String)>
        let sections: BehaviorRelay<[ExclItemInfoModalSection]>
        let exclInfo: BehaviorRelay<ExclItem>
    }
    
    func transform(input: Input) -> Output {
        let sections = BehaviorRelay<[ExclItemInfoModalSection]>(value: [])
        let exclInfo = BehaviorRelay<ExclItem>(value: ExclItem(name: "", price: 0, csInfoIdx: ""))
        
        let title = input.title
        let titleTextFieldCount = BehaviorRelay<String>(value: "")
        let titleTextFieldIsValid = BehaviorRelay<Bool>(value: true)
        let titleResult = BehaviorRelay<String>(value: "")
        let priceResult = BehaviorRelay<Int>(value: 0)
        let numberFormatter = NumberFormatterHelper()
        let showAlertRelay = PublishRelay<(String, String)>()
        let alertItem = BehaviorRelay<(String, String)>(value: ("", ""))

        let priceLimit = BehaviorRelay<Int>(value: 0)
        let priceIsLimited = input.price
            .map { price in
                let priceInt = numberFormatter.number(from: price)
                return priceInt ?? 0 >= priceLimit.value
            }
            .asDriver(onErrorJustReturn: false)
        
        let addButtonIsEnable: Driver<Bool>
        
        input.title
            .drive(titleResult)
            .disposed(by: disposeBag)
        
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
        
        input.editButtonTapped
            .asDriver()
            .withLatestFrom(csInfoDriver)
            .drive(onNext: { [weak self] title, price in
                guard let self = self else { return }

                createService.editExclItem(exclItemIdx: exclItemIdx,
                                           name: titleResult.value,
                                           price: priceResult.value)
                
                // MARK: 현재 Table의 정보와 Repo의 exclMember를 비교하여 toggle 메서드 호출
                /// table, repo의 member 순서가 다르므로 2중 for문으로 완전탐색
                /// 조건 1 : table의 isTarget과 repo의 isTarget이 다를때
                /// 조건 2 : table의 name과 repo의 name이 같을 때
                /// 조건1, 조건2가 모두 맞으면 해당 repo의 exclMemberIdx로 toggle 메소드를 호출함.
                let curExclMember = sections.value[0].items
                
                createService.exclMemberRelay.value.forEach { [weak self] exclMember in
                    guard let self = self else { return }
                    
                    if exclMember.exclItemIdx == exclItemIdx {
                        for item in curExclMember {
                            if item.isTarget != exclMember.isTarget,
                               item.name == exclMember.name {
                                let toggleExclMemberIdx = exclMember.exclMemberIdx
                                createService.toggleExclMember(exclMemberIdx: toggleExclMemberIdx)
                            }
                        }
                    }
                }
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
        
        let currentMembers = BehaviorRelay<[CSMember]>(value: createService.csMemberArr)
        
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
        
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                sections.accept([self.setSectionsByExclItemIdx(exclItemIdx: self.exclItemIdx)])
                exclInfo.accept(createService.exclItemRelay.value.first(where: {$0.exclItemIdx == self.exclItemIdx})!)
            })
            .disposed(by: disposeBag)
        
        titleResult
            .asDriver()
            .drive(onNext: { [weak self] title in
                guard let self = self else { return }
                alertItem.accept((self.exclItemIdx, title))
            })
            .disposed(by: disposeBag)

        input.deleteButtonTapped
            .withLatestFrom(alertItem)
            .asDriver(onErrorJustReturn: (("", "")))
            .drive(onNext: {
                showAlertRelay.accept($0)
            })
            .disposed(by: disposeBag)
        
        input.isActiveRelay
            .asDriver()
            .drive(onNext: { isActive in
                var sectionValue = sections.value
                sectionValue[0].isActive = isActive
                sections.accept(sectionValue)
            })
            .disposed(by: disposeBag)
        
        return Output(titleCount: titleTextFieldCount.asDriver(),
                      price: priceString,
                      titleTextFieldIsValid: titleTextFieldIsValid,
                      priceIsLimited: priceIsLimited,
                      addButtonIsEnable: addButtonIsEnable,
                      titleTextFieldControlEvent: titleTFControlEvent,
                      priceTextFieldControlEvent: priceTFControlEvent,
                      cancelButtonTapped: input.cancelButtonTapped.asDriver(),
                      editButtonTapped: input.editButtonTapped.asDriver(),
                      showAlertVC: showAlertRelay.asDriver(onErrorJustReturn: ("", "")),
                      sections: sections,
                      exclInfo: exclInfo
        )
    }

    private func setSectionsByExclItemIdx(exclItemIdx: String) -> ExclItemInfoModalSection {
        let currentExclMember = createService.exclMemberRelay.value.filter{$0.exclItemIdx == exclItemIdx}
        let exclitemTables = currentExclMember.map { exclMember -> ExclItemTable in
            let item = ExclItemTable(name: exclMember.name, isTarget: exclMember.isTarget)
            return item
        }
        
        return ExclItemInfoModalSection(isActive: false, items: exclitemTables)
    }
    
    private func calculatePriceLimit() -> Driver<Int> {
        var priceLimitValue = createService.csInfo.totalAmount
        
        for item in createService.exclItemRelay.value {
            if item.exclItemIdx != self.exclItemIdx {
                priceLimitValue -= item.price
            }
        }
        
        let priceLimitDriver = Driver<Int>.just(priceLimitValue)
        return priceLimitDriver
    }
}

