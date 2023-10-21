//
//  CSMemberEditVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/21.
//

import RxSwift
import RxCocoa
import UIKit

class CSMemberEditVM {
    
    var disposeBag = DisposeBag()
    
    let maxTextCount = 12
    
    let memberList = SplitRepository.share.csMemberArr
    let isOverayViewHidden = BehaviorRelay<Bool>(value: false) // CSMemberInputVC
    let currentSearchText = BehaviorRelay<String>(value: "") // CSMemberInputSearchFooter
    
    struct Input {
        let viewDidLoad: Driver<Void>
        let nextButtonTapSend: Driver<Void>
        let searchBarText: Driver<String>
    }
    
    struct Output {
        let memberList: BehaviorRelay<[CSMember]>
        let searchList: BehaviorRelay<[String]>
        let showCSMemberConfirmView: Driver<Void>
        let isOverlayingSearchView: Driver<Bool>
        let textFieldCounter: Driver<String>
        let textFieldIsValid: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let maxTextCount = maxTextCount
        let searchList = BehaviorRelay<[String]>(value: [])
        
        let memberListValue = memberList.value.map { $0.name }
        let memberNameList = BehaviorRelay<[String]>(value: memberListValue)
        
        let memberLogList = SplitRepository.share.memberLogArr
        let memberLogNameList = BehaviorRelay<Set<String>>(value: Set())
        
        let searchBarText = input.searchBarText.asDriver()
        let textFieldCount = BehaviorRelay<Int>(value: 0)
        let textFieldCounter = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        let showCSMemberConfirmView = input.nextButtonTapSend.asDriver()

        memberList
            .asDriver()
            .map { $0.map { $0.name } }
            .drive(memberNameList)
            .disposed(by: disposeBag)
        
        memberLogList
            .asDriver()
            .map { $0.map {$0.name} }
            .map{Set($0)}
            .drive(memberLogNameList)
            .disposed(by: disposeBag)

        // MARK: Repository로부터 MemberLog를 fetch
        input.viewDidLoad
            .drive(onNext: {
                SplitRepository.share.fetchMemberLog()
            })
            .disposed(by: disposeBag)
        
        // MARK: output: textFieldCounter
        isOverayViewHidden
            .asDriver(onErrorJustReturn: false)
            .map{ _ in String("0/\(self.maxTextCount)") }
            .drive(textFieldCounter)
            .disposed(by: disposeBag)

        // 현재 입력한 text의 개수를 textFieldCount에 drive
        searchBarText
            .map{ $0.count }
            .drive(textFieldCount)
            .disposed(by: disposeBag)

        // MARK: 현재 입력한 text를 maxTextCount 제한에 맞추어 Relay에 accept
        searchBarText
            .map {text in
                if text.count <= maxTextCount {
                    return text
                } else {
                    let endIndex = text.index(text.startIndex, offsetBy: maxTextCount)
                    return String(text[text.startIndex..<endIndex])
                }
            }
            .drive(currentSearchText)
            .disposed(by: disposeBag)
        
        // MARK: output: SearchList (SearchList 로직)
        /// 현재 멤버에 존재하지 않으면서, MemberLog에 존재하는 현재 입력한 text를 포함하는 [String] 타입을 drive
        searchBarText
            .map { text in
                let memberNameSet = Set(memberNameList.value)
                let memberLogSet = Set(memberLogNameList.value)
                
                let intersection = memberLogSet.intersection(memberNameSet)
                let excludeMemberNameInMemberLogArray = Array(memberLogSet.subtracting(intersection))

                let nameMatchAndExcludeCurrentMemberMemberLogList = excludeMemberNameInMemberLogArray.filter{$0.contains(text)}
                return nameMatchAndExcludeCurrentMemberMemberLogList
            }
            .drive(searchList)
            .disposed(by: disposeBag)
        
        // MARK: output: isOverayViewHidden
        /// 현재 입력한 text가 없으면 searchBar를 Hidden
        searchBarText
            .map { $0.count == 0 }
            .drive(isOverayViewHidden)
            .disposed(by: disposeBag)
        
        // TextFieldCounter
        searchBarText
            .map { [weak self] text in
                guard let self = self else { return "" }
                let currentTextCount = text.count > self.maxTextCount ? text.count - 1 : text.count
                return "\(currentTextCount)/\(self.maxTextCount)"
            }
            .drive(textFieldCounter)
            .disposed(by: disposeBag)
        
        // MARK: output: textFieldIsValid
        searchBarText
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(textFieldIsValid)
            .disposed(by: disposeBag)
        
        showCSMemberConfirmView
            .map { }
            .drive { _ in
//                SplitRepository.share.createCSMember(name: )
                print("\(SplitRepository.share.csMemberArr.value.map({ $0.name })))")
                SplitRepository.share.updateDataToDB()
            }

        return Output(memberList: memberList,
                      searchList: searchList,
                      showCSMemberConfirmView: showCSMemberConfirmView,
                      isOverlayingSearchView: isOverayViewHidden.asDriver(onErrorJustReturn: false),
                      textFieldCounter: textFieldCounter.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver())
    }
    
    // 입력한 name이 memberLog에 존재하는지 확인하여 존재하지 않는지 여부를 Bool type으로 반환
    func canAddMemberLogWithName(name: String) -> Bool {
        return !SplitRepository.share.memberLogArr.value.map{$0.name}.contains(name)
    }
 }
