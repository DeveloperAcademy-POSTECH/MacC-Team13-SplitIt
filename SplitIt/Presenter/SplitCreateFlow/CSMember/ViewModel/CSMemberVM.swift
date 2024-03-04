//
//  NewCSMemberVM.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/09.
//

import Foundation
import RxCocoa
import RxSwift

class CSMemberVM {
    let createService: CreateServiceType
    let memberLogService: MemberLogServiceType
    let disposeBag = DisposeBag()
    
    init(createService: CreateServiceType,
         memberLogService: MemberLogServiceType
    ) {
        self.createService = createService
        self.memberLogService = memberLogService
    }
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let textFieldValue: Driver<String>
        let textFieldReturnKeyTapped: PublishRelay<Void>
        let searchCellTapped: ControlEvent<IndexPath>
        let selectedCellTapped: ControlEvent<IndexPath>
        let addButtonTapped: ControlEvent<Void>
        let nextButtonTapped: ControlEvent<Void>
        let exitButtonTapped: ControlEvent<Void>
        let backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let searchMemberArr: BehaviorRelay<[MemberCheck]>
        let selectedMemberArr: BehaviorRelay<[MemberCheck]>
        let isCellAppear: BehaviorRelay<Bool>
        let deleteIndex: BehaviorRelay<Int>
        let textFieldValue: BehaviorRelay<String>
        let showNextVC: Driver<Void>
        let showExitAlert: Driver<Void>
        let backToPreVC: Driver<Void>
        let textCount: BehaviorRelay<String>
    }
    
    func transform(input: Input) -> Output {
        let maxTextCount = 8
        
        let allMemberArr = BehaviorRelay<[MemberCheck]>(value: [])
        let searchMemberArr = BehaviorRelay<[MemberCheck]>(value: [])
        let selectedMemberArr = BehaviorRelay<[MemberCheck]>(value: self.setSelectedMember())
        
        let isCellAppearRelay = BehaviorRelay(value: true)
        let deleteIndexRelay = BehaviorRelay(value: 0)
        let textFieldValue = BehaviorRelay(value: "")
        let textCount = BehaviorRelay(value: "| 0/8자")
        
        let showNextVC: Driver<Void> = input.nextButtonTapped.asDriver()
        let showExitAlert: Driver<Void> = input.exitButtonTapped.asDriver()
        let backToPreVC: Driver<Void> = input.backButtonTapped.asDriver()
        
        let hapticManager = HapticManager()
        
        memberLogService.fetchMemberLog()
            .map { memberLogArr in
                let memberCheckArr = memberLogArr
                    .map { member in
                        MemberCheck(name: member.name)
                    }
                    .map { memberCheck in
                        var check = memberCheck
                        if selectedMemberArr.value.map({ $0.name }).contains(memberCheck.name) {
                            check.isCheck = true
                        }
                        return check
                    }
                
                return memberCheckArr
            }
            .subscribe(onNext: { memberCheckArr in
                allMemberArr.accept(memberCheckArr)
            })
            .disposed(by: disposeBag)
        
        input.textFieldValue
            .map { text in
                var fixText: String = text
                
                if text.count > maxTextCount {
                    fixText.removeLast()
                }
                
                return fixText
            }
            .drive(textFieldValue)
            .disposed(by: disposeBag)
        
        input.textFieldValue
            .map { text -> String in
                let count = text.count
                
                return "\(count)/8자"
            }
            .drive(textCount)
            .disposed(by: disposeBag)
        
        // inputText와 allMemberArr 중 변경이 일어났을 때 해당 내용을 searchMemberArr에 반영
        Driver.combineLatest(textFieldValue.asDriver(), allMemberArr.asDriver())
            .drive(onNext: { text, allMembers in
                let filteredMember = allMembers.filter { $0.name.contains(text.lowercased()) || $0.name.contains(text.uppercased()) }
                
                text == "" ? searchMemberArr.accept(allMembers) : searchMemberArr.accept(filteredMember)
            })
            .disposed(by: disposeBag)
        
        // searchCell을 탭 했을 때 allMemberArr의 해당 isCheck를 바꿔주고 isCheck가 true면 selectedMemberArr에 넣어주고 false면 빼주기
        input.searchCellTapped.asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let selectMember = searchMemberArr.value[indexPath.row]
                
                if !selectMember.isCheck {
                    var currentSelectedMemberArr = selectedMemberArr.value
                    isCellAppearRelay.accept(true)
                    currentSelectedMemberArr.insert(selectMember, at: 0)
                    selectedMemberArr.accept(currentSelectedMemberArr)
                } else {
                    var currentSelectedMemberArr = selectedMemberArr.value
                    if let deleteIndex = currentSelectedMemberArr.map({ $0.name }).firstIndex(of: selectMember.name) {
                        isCellAppearRelay.accept(false)
                        deleteIndexRelay.accept(deleteIndex)
                        currentSelectedMemberArr.remove(at: deleteIndex)
                        selectedMemberArr.accept(currentSelectedMemberArr)
                    }
                }
                
                allMemberArr.accept(self.tranformIsCheckInSelectMemberArr(allMemberArrValue: allMemberArr.value, name: selectMember.name))
                
                hapticManager.hapticImpact(style: .light)
            })
            .disposed(by: disposeBag)
        
        // selectedMember를 탭 했을 때 allMemberArr를 변경해서 searchMemberArr, selectedMemberArr 둘 다 변경
        input.selectedCellTapped.asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let selectedMember = selectedMemberArr.value[indexPath.row]
                if selectedMember.name == "정산자" { return }
                
                var currentSelectedMemberArr = selectedMemberArr.value
                
                isCellAppearRelay.accept(false)
                deleteIndexRelay.accept(indexPath.row)
                
                if let deleteIndex = currentSelectedMemberArr.firstIndex(of: selectedMember) {
                    currentSelectedMemberArr.remove(at: deleteIndex)
                    selectedMemberArr.accept(currentSelectedMemberArr)
                }
                
                allMemberArr.accept(self.tranformIsCheckInSelectMemberArr(allMemberArrValue: allMemberArr.value, name: selectedMember.name))
            })
            .disposed(by: disposeBag)
        
        // + 버튼을 눌렀을 때 확인해서 동작
        Driver.merge(input.addButtonTapped.asDriver(), input.textFieldReturnKeyTapped.asDriver(onErrorJustReturn: ()))
            .withLatestFrom(textFieldValue.asDriver())
            .drive(onNext: { [weak self] name in
                guard let self = self else { return }
                let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if name == "" || name == "정산자" { return }
                if selectedMemberArr.value.map({ $0.name }).contains(name) { return }
                
                var currentSelectedMemberArr = selectedMemberArr.value
                
                let newSelectMember = MemberCheck(name: name, isCheck: true)
                currentSelectedMemberArr.insert(newSelectMember, at: 0)
                isCellAppearRelay.accept(true)
                selectedMemberArr.accept(currentSelectedMemberArr)
                
                if allMemberArr.value.map({ $0.name }).contains(name) {
                    allMemberArr.accept(self.tranformIsCheckInSelectMemberArr(allMemberArrValue: allMemberArr.value, name: name))
                } else if !allMemberArr.value.map({ $0.name }).contains(name) && name != "정산자" {
                    var currentAllMemberArr = allMemberArr.value
                    currentAllMemberArr.append(newSelectMember)
                    allMemberArr.accept(currentAllMemberArr)
                    self.memberLogService.createMemberLog(name: name)
                }
                
                searchMemberArr.accept(allMemberArr.value)
                
                hapticManager.hapticNotification(type: .success)
                
                textFieldValue.accept("")
            })
            .disposed(by: disposeBag)
        
        Driver.merge(showNextVC, backToPreVC)
            .drive(onNext: { [weak self] _ in
                self?.createService.createCSMembers(names: selectedMemberArr.value.map({ $0.name }))
            })
            .disposed(by: disposeBag)
        
        return Output(searchMemberArr: searchMemberArr,
                      selectedMemberArr: selectedMemberArr,
                      isCellAppear: isCellAppearRelay,
                      deleteIndex: deleteIndexRelay,
                      textFieldValue: textFieldValue,
                      showNextVC: showNextVC,
                      showExitAlert: showExitAlert,
                      backToPreVC: backToPreVC,
                      textCount: textCount)
    }
    
    private func setSelectedMember() -> [MemberCheck] {
        var members = createService.csMemberArr.map {
            MemberCheck(name: $0.name, isCheck: true)
        }
        
        if members.last?.name != "정산자" {
            members.reverse()
        }
        
        return members
    }
    
    private func tranformIsCheckInSelectMemberArr(allMemberArrValue: [MemberCheck], name: String) -> [MemberCheck] {
        var allmembers = allMemberArrValue
        
        for i in 0..<allMemberArrValue.count {
            if allmembers[i].name == name {
                allmembers[i].isCheck.toggle()
                break
            }
        }
        
        return allmembers
    }
}
 
