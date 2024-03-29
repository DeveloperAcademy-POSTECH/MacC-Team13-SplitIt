//
//  NewEditCSMemberVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/11/13.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class EditCSMemberVM {
    
    let disposeBag = DisposeBag()
    let maxTextCount = 8
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let textFieldValue: Driver<String>
        let textFieldReturnKeyTapped: PublishRelay<Void>
        let searchCellTapped: ControlEvent<IndexPath>
        let selectedCellTapped: ControlEvent<IndexPath>
        let backButtonTapped: ControlEvent<Void>
        let addButtonTapped: ControlEvent<Void>
        let saveButtonTapped: ControlEvent<Void>
        let swipeBack: Observable<UIScreenEdgePanGestureRecognizer>
    }
    
    struct Output {
        let searchMemberArr: BehaviorRelay<[MemberCheck]>
        let selectedMemberArr: BehaviorRelay<[MemberCheck]>
        let isCellAppear: BehaviorRelay<Bool>
        let deleteIndex: BehaviorRelay<Int>
        let textFieldIsValid: BehaviorRelay<Bool>
        let textFieldValue: BehaviorRelay<String>
        let showExclItemVC: ControlEvent<Void>
        let showBackAlert: Observable<Void>
        let textCount: BehaviorRelay<String>
        let isEdited: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let isEdited = BehaviorRelay<Bool>(value: false)
        let repo = SplitRepository.share
        let allMemberArr = BehaviorRelay<[MemberCheck]>(value: [])
        let searchMemberArr = BehaviorRelay<[MemberCheck]>(value: [])
        let selectedMemberArr = BehaviorRelay<[MemberCheck]>(value: repo.csMemberArr.value.map { MemberCheck(name: $0.name, isCheck: true) }.reversed())
        let selectedMemberBefore = BehaviorRelay<[MemberCheck]>(value: repo.csMemberArr.value.map { MemberCheck(name: $0.name, isCheck: true) }.reversed())
        
        let isCellAppearRelay = BehaviorRelay(value: true)
        let deleteIndexRelay = BehaviorRelay(value: 0)
        let textFieldIsValid = BehaviorRelay<Bool>(value: true)
        let textFieldValue = BehaviorRelay(value: "")
        let textCount = BehaviorRelay(value: "| 0/8자")
        
        let showExclItemVC = input.saveButtonTapped
        
        let hapticManager = HapticManager()
        
        // 현재 csMember에 들어가 있는 값은 처음 뷰에 들어올 때부터 selectedMemberArr에 들어가 있어야하고 isCheck도 true여야 한다
        input.viewWillAppear.asDriver(onErrorJustReturn: true)
            .drive(onNext: { _ in
                repo.fetchMemberLog()
                allMemberArr.accept(repo.memberLogArr.value.map { MemberCheck(name: $0.name) })
                
                var allMembers = allMemberArr.value
                
                for i in 0..<allMembers.count {
                    if selectedMemberArr.value.map({ $0.name }).contains(allMembers[i].name) {
                        allMembers[i].isCheck = true
                    }
                }
                
                allMemberArr.accept(allMembers)
            })
            .disposed(by: disposeBag)
        
        input.textFieldValue
            .map { [weak self] text in
                guard let self = self else { return "" }
                var fixText: String = text
                
                if text.count > self.maxTextCount {
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
            .drive(onNext: { indexPath in
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
            .drive(onNext: { indexPath in
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
            .withLatestFrom(input.textFieldValue)
            .drive(onNext: { name in
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
                    repo.createMemberLog(name: name)
                }
                
                searchMemberArr.accept(allMemberArr.value)
                
                hapticManager.hapticNotification(type: .success)
                
                textFieldValue.accept("")
            })
            .disposed(by: disposeBag)
        
        // 버튼 탭 시 repo에 있는 csMemberArr를 업데이트하고 기존 검색기록에 없던 이름은 검색기록에 추가
//        input.saveButtonTapped
//            .asDriver()
//            .drive(onNext: {
//                var selectedMemberNameArr = selectedMemberArr.value.map { $0.name }
//
//                for name in selectedMemberNameArr {
//                    if !allMemberArr.value.map({ $0.name }).contains(name) && name != "정산자" {
//                        repo.createMemberLog(name: name)
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
        
        // 멤버 선택 시 SplitRepository의 csMember에 바로 적용
        selectedMemberArr
            .asDriver()
            .drive(onNext: { member in
                var selectedMemberNameArr = member.map { $0.name }
                selectedMemberNameArr.reverse()
                repo.createCSMemberArr(nameArr: selectedMemberNameArr)
            })
            .disposed(by: disposeBag)
        
        selectedMemberArr
            .asDriver()
            .map { [weak self] _ in
                guard let self = self else { return false }
                let beforeMember = selectedMemberBefore.value
                let afterMember = selectedMemberArr.value
                return checkMemberIsEdited(beforeMember, afterMember)
            }
            .drive(isEdited)
            .disposed(by: disposeBag)
        
        let showBackAlert = Observable.merge(input.backButtonTapped.asObservable(),
                                             input.swipeBack.map{ _ in }.asObservable())
        
        return Output(searchMemberArr: searchMemberArr,
                      selectedMemberArr: selectedMemberArr,
                      isCellAppear: isCellAppearRelay,
                      deleteIndex: deleteIndexRelay,
                      textFieldIsValid: textFieldIsValid,
                      textFieldValue: textFieldValue,
                      showExclItemVC: showExclItemVC,
                      showBackAlert: showBackAlert,
                      textCount: textCount,
                      isEdited: isEdited)
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
    
    private func checkMemberIsEdited(_ before: [MemberCheck],
                                     _ after: [MemberCheck]) -> Bool {
        let beforeSorted = before.sorted { $0.name < $1.name }
        let afterSorted = after.sorted { $0.name < $1.name }
        
        if beforeSorted.count != afterSorted.count {
            return true
        }

        for (beforeElem, afterElem) in zip(beforeSorted, afterSorted) {
            if beforeElem.name != afterElem.name {
                return true
            }
        }

        return false
    }
}
 

