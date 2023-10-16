//
//  CSMemberInputVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/16.
//

import RxSwift
import RxCocoa
import UIKit

class CSMemberInputVM {
    
    var disposeBag = DisposeBag()
    
    let maxTextCount = 12
    
    let memberList = BehaviorRelay<[String]>(value: []) // CSMemberInputCell에서 사용
    let isOverayViewHidden = BehaviorRelay<Bool>(value: false) // CSMemberInputVC
    let currentSearchText = BehaviorRelay<String>(value: "") // CSMemberInputSearchFooter
    
    struct Input {
        let viewDidLoad: Driver<Void> // viewDidLoad
        let nextButtonTapSend: Driver<Void> // 다음 버튼
        let searchBarText: Driver<String> // TitleTextField의 text
    }
    
    struct Output {
        let memberList: BehaviorRelay<[String]>
        let searchList: BehaviorRelay<[String]>
        let showCSMemberConfirmView: Driver<Void>
        let isOverlayingSearchView: Driver<Bool>
        let textFieldCounter: Driver<String>
        let textFieldIsValid: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let searchList = BehaviorRelay<[String]>(value: [])
        let searchBarText = input.searchBarText
        let textFieldCount = BehaviorRelay<Int>(value: 0)
        let textFieldCounter = BehaviorRelay<String>(value: "")
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        let showCSMemberConfirmView = input.nextButtonTapSend.asDriver()
        let searchListDB = BehaviorRelay<[String]>(value: []) // Dummy

        // 현재 차수의 members, DB 세팅
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.memberList.accept(["나의닉네임","코리","제롬","토마토","제리","모아나"])
                searchListDB.accept(["가","가나","가나다","나","나다라","나다라마","다라마바"])
                
                let currentTitle = CreateStore.shared.getCurrentCSInfoTitle()
            })
            .disposed(by: disposeBag)

        searchBarText
            .map{ $0.count }
            .drive(textFieldCount)
            .disposed(by: disposeBag)
        
        searchBarText
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count <= self.maxTextCount {
                    self.currentSearchText.accept(text)
                } else {
                    let endIndex = text.index(text.startIndex, offsetBy: self.maxTextCount)
                    self.currentSearchText.accept(String(text[text.startIndex..<endIndex]))
                }
                
                // 검색창의 text에 따라 DB에서 필터링
                let db = searchListDB.value
                let list = db.filter { $0.contains(text) }
                searchList.accept(list)
            })
            .disposed(by: disposeBag)
            
        // SearchBar Display
        searchBarText
            .map { $0.count > 0 }
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
        
        // TextField Input Valid
        searchBarText
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                return text.count < self.maxTextCount
            }
            .drive(textFieldIsValid)
            .disposed(by: disposeBag)
        
        showCSMemberConfirmView
            .withLatestFrom(self.memberList.asDriver(onErrorJustReturn: []))
            .drive(onNext: {
                CreateStore.shared.setCurrentCSInfoCSMember(members: $0)
                CreateStore.shared.printAll()
            })
            .disposed(by: disposeBag)
        
        isOverayViewHidden
            .asDriver(onErrorJustReturn: false)
            .map{ _ in String("0/\(self.maxTextCount)") }
            .drive(textFieldCounter)
            .disposed(by: disposeBag)

        return Output(memberList: memberList,
                      searchList: searchList,
                      showCSMemberConfirmView: showCSMemberConfirmView,
                      isOverlayingSearchView: isOverayViewHidden.asDriver(onErrorJustReturn: false),
                      textFieldCounter: textFieldCounter.asDriver(),
                      textFieldIsValid: textFieldIsValid.asDriver())
    }
}

