//
//  SplitRepository.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class SplitRepository {
    
    static let share = SplitRepository()
    private let disposeBag = DisposeBag()
    
    let splitArr = BehaviorRelay<[Split]>(value: [])
    let csInfoArr = BehaviorRelay<[CSInfo]>(value: [])
    let exclItemArr = BehaviorRelay<[ExclItem]>(value: [])
    let exclMemberArr = BehaviorRelay<[ExclMember]>(value: [])
    let csMemberArr = BehaviorRelay<[CSMember]>(value: [])
    let memberLogArr = BehaviorRelay<[MemberLog]>(value: [])
    
    private var currentCSInfo: CSInfo?
    private var newExclItem: ExclItem?
}

extension SplitRepository {
    
    /// DB에서 날짜를 기준으로 5개의 split만 필터링해서 하위 모든 Arr 패치 -> MainView
    func fetchSplitArrFromDBForMainView() {
        let realmManager = RealmManager()
        splitArr.accept(realmManager.bringSplitWithCount(bringCount: 5))
        fetchAllDataBaseSplit(false, realmManager: realmManager)
    }
    
    /// DB에서 날짜를 기준으로 20개(임시 - 그냥 다 불러와도 되긴 함)의 split만 필터링해서 하위 모든 Arr 패치
    func fetchSplitArrFromDBForHistoryView() {
        let realmManager = RealmManager()
        splitArr.accept(realmManager.bringSplitWithCount(bringCount: 20))
        fetchAllDataBaseSplit(false, realmManager: realmManager)
    }
    
    /// splitIdx가 일치하는 split만 필터링해서 하위 모든 Arr 패치
    func fetchSplitArrFromDBWithSplitIdx(splitIdx: String) {
        let realmManager = RealmManager()
        splitArr.accept(realmManager.bringSplitWithSplitIdx(splitIdx: splitIdx))
        fetchAllDataBaseSplit(false, realmManager: realmManager)
    }
    
    /// memberLog 전체를 패치
    func fetchMemberLog() {
        self.memberLogArr.accept(RealmManager().bringMemberLogAll())
    }
    
    /// false면 split 기준, true면 csInfo 기준으로 하위 데이터 모두를 패치
    private func fetchAllDataBaseSplit(_ isCSInfoStart: Bool, realmManager: RealmManager) {
        if !isCSInfoStart {
            let splitIdxArr: [String] = splitArr.value.map { $0.splitIdx }
            csInfoArr.accept(realmManager.bringCSInfoWithSplitIdxArr(splitIdxArr: splitIdxArr))
        }
        
        let csInfoIdxArr: [String] = csInfoArr.value.map { $0.csInfoIdx }
        csMemberArr.accept(realmManager.bringCSMemberWithCSInfoIdxArr(csInfoIdxArr: csInfoIdxArr))
        exclItemArr.accept(realmManager.bringExclItemWithCSInfoIdxArr(csInfoIdxArr: csInfoIdxArr))
        
        let exclItemIdxArr: [String] = exclItemArr.value.map { $0.exclItemIdx }
        exclMemberArr.accept(realmManager.bringExclMemberWithExclItemIdxArr(exclItemIdxArr: exclItemIdxArr))
    }
}

extension SplitRepository {
    
    /// 새로운 split, csInfo, csMember(default: 나) 생성 => MainView에서 split it 버튼 클릭시 호출되도록 설정
    func createDatasForCreateFlow() {
        let newSplit = Split()
        let newCSInfo = CSInfo(splitIdx: newSplit.splitIdx)
        let newCSMember = CSMember(csInfoIdx: newCSInfo.csInfoIdx, name: "나")
        
        currentCSInfo = newCSInfo
        
        splitArr.accept([newSplit])
        csInfoArr.accept([newCSInfo])
        csMemberArr.accept([newCSMember])
        exclItemArr.accept([])
        exclMemberArr.accept([])
    }
    
    /// 현재 csInfoIdx를 기준으로 원하는 값을 이름으로 가지는 csMember 생성 - 기존 친구 목록에 없는 경우 동작
    func createCSMember(name: String) {
        var csMembers: [CSMember] = csMemberArr.value
        let newCSMember: CSMember = CSMember(csInfoIdx: currentCSInfo!.csInfoIdx, name: name)
        csMembers.append(newCSMember)
        csMemberArr.accept(csMembers)
    }
    
    // TODO: 친구 목록에 있는 경우 친구모델에서 name만 빼와서 csMember 생성 - 기존 친구 목록에 있는 경우 동작
    func createCSMemberFromFriend() {
        
    }
    
    /// CSInfoIdx, name으로 ExclItem 생성
    func createExclItemWithName(name: String) {
        let newExclItem: ExclItem = ExclItem(csInfoIdx: currentCSInfo!.csInfoIdx, name: name)
        self.newExclItem = newExclItem
    }
    
    /// 현재 splitIdx를 기준으로 CSInfo부터 아래 데이터들만 새로 생성
    func createNewCS() {
        let splitIdx = splitArr.value.first!.splitIdx
        let newCSInfo = CSInfo(splitIdx: splitIdx)
        let newCSMember = CSMember(csInfoIdx: newCSInfo.csInfoIdx, name: "나")
        
        currentCSInfo = newCSInfo
        
        csInfoArr.accept([newCSInfo])
        csMemberArr.accept([newCSMember])
    }
    
    /// name을 받아서 memberLogArr, realm에 새로 생성
    func createMemberLog(name: String) {
        RealmManager().updateData(memberLog: MemberLog(name: name))
        fetchMemberLog()
    }
    
    /// ExclItem 및 CSMember에 따라 ExclMember 생성
    private func createExclMember(exclItemIdx: String) {
        let csMemberNames: [String] = csMemberArr.value.map { $0.name }
        var exclMembers: [ExclMember] = exclMemberArr.value
        
        for name in csMemberNames {
            let newExclMember: ExclMember = ExclMember(exclItemIdx: exclItemIdx, name: name)
            exclMembers.append(newExclMember)
        }
        
        exclMemberArr.accept(exclMembers)
    }
}

extension SplitRepository {
    
    /// 현재 csInfo의 title 변경
    func inputCSInfoWithTitle(title: String) {
        currentCSInfo!.title = title
    }
    
    /// 현재 csInfo의 totalAmount 변경
    func inputCSInfoWithTotalAmount(totalAmount: Int) {
        currentCSInfo!.totalAmount = totalAmount
        csInfoArr.accept([currentCSInfo!])
    }
    
    /// 만든 ExclItem에 price 넣고 exclItemArr 업뎅이트
    func inputExclItemPrice(price: Int) {
        var exclItems: [ExclItem] = exclItemArr.value
        var newExclItem: ExclItem = self.newExclItem!
        newExclItem.price = price
        exclItems.append(newExclItem)
        exclItemArr.accept(exclItems)
        
        createExclMember(exclItemIdx: newExclItem.exclItemIdx)
    }
    
    /// csInfoIdx가 일치하는 csInfo만 필터링해서 하위 모든 Arr 패치
    func inputCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: String) {
        let realmManager = RealmManager()
        csInfoArr.accept(realmManager.bringCSInfoWithCSInfoIdx(csInfoIdx: csInfoIdx))
        
        guard let split = csInfoArr.value.first else { return }
        let splitIdx = split.splitIdx
        splitArr.accept(realmManager.bringSplitWithSplitIdx(splitIdx: splitIdx))
        
        fetchAllDataBaseSplit(true, realmManager: realmManager)
        
        print(splitArr.value)
        print(csInfoArr.value)
        print(csMemberArr.value)
        print(exclItemArr.value)
        print(exclMemberArr.value)
    }
}

extension SplitRepository {
    
    /// 현재 split의 title을 수정
    func editSplitTitle(title: String) {
        let realmManager = RealmManager()
        
        let splits: [Split] = splitArr.value
        var split: Split = splits.first!
        split.title = title
        split.createDate = Date.now
        splitArr.accept([split])
        realmManager.updateData(splitArr: [split])
    }
    
    /// csInfo 이름 수정 - 수정 시 바로 realm에도 반영
    func editCSInfoTitle(title: String) {
        let realmManager = RealmManager()
        
        let csInfos: [CSInfo] = csInfoArr.value
        var csInfo: CSInfo = csInfos.first!
        csInfo.title = title
        csInfoArr.accept([csInfo])
        realmManager.updateData(csInfoArr: [csInfo])
    }
    
    /// csInfo 가격 수정 - 수정 시 바로 realm에도 반영
    func editCSInfoTotalAcount(totalAcount: Int) {
        let realmManager = RealmManager()
        
        let csInfos: [CSInfo] = csInfoArr.value
        var csInfo: CSInfo = csInfos.first!
        csInfo.totalAmount = totalAcount
        csInfoArr.accept([csInfo])
        realmManager.updateData(csInfoArr: [csInfo])
    }
    
    /// exclItemIdx를 기준으로 exclItem 이름 수정 - realm에는 수정 안됨 플로우 확인 후 각각 해주거나 한번에 해주기
    func editExclItemName(exclItemIdx: String, name: String) {
        var exclItems: [ExclItem] = exclItemArr.value
        
        for i in 0...exclItems.count-1 {
            if exclItems[i].exclItemIdx == exclItemIdx {
                exclItems[i].name = name
            }
        }
        
        exclItemArr.accept(exclItems)
    }
    
    /// exclItemIdx를 기준으로 exclItem 가격 수정 - realm에는 수정 안됨 플로우 확인 후 각각 해주거나 한번에 해주기
    func editExclItemPrice(exclItemIdx: String, price: Int) {
        var exclItems: [ExclItem] = exclItemArr.value
        
        for i in 0...exclItems.count-1 {
            if exclItems[i].exclItemIdx == exclItemIdx {
                exclItems[i].price = price
            }
        }
        
        exclItemArr.accept(exclItems)
    }
    
    /// split의 createDate를 현재시간으로 수정
    private func editSplitCreateDate() {
        let splits: [Split] = splitArr.value
        var split: Split = splits.first!
        split.createDate = Date.now
        splitArr.accept([split])
    }
}

extension SplitRepository {
    
    /// splitIdx를 기준으로 split 삭제 및 연관 데이터 전체 삭제
    func deleteSplitAndRelatedData(splitIdx: String) {
        let realmManager = RealmManager()
        let splits: [Split] = splitArr.value
        var deleteSplit: Split?
        var newSplits: [Split] = []
        
        for split in splits {
            if split.splitIdx == splitIdx {
                deleteSplit = split
            } else {
                newSplits.append(split)
            }
        }
        
        splitArr.accept(newSplits)
        realmManager.deleteSplit(splitIdx: deleteSplit!.splitIdx)
        
        // csInfo 삭제
        let csInfoIdxArr = deleteCSInfo(splitIdx: splitIdx, realmManager: realmManager)
        
        // csMember 삭제
        deleteCSMember(csInfoIdxArr: csInfoIdxArr, realmManager: realmManager)
        
        // exclItem 및 exclMember 삭제
        deleteExclItem(csInfoIdxArr: csInfoIdxArr, realmManager: realmManager)
    }
    
    /// csInfoIdx를 기준으로 csInfo 삭제 및 연관 데이터 전체 삭제
    func deleteCSInfoAndRelatedData(csInfoIdx: String) {
        let realmManager = RealmManager()
        let csInfos: [CSInfo] = csInfoArr.value
        var deleteCSInfo: CSInfo?
        var newCSInfos: [CSInfo] = []
        
        for info in csInfos {
            if info.csInfoIdx == csInfoIdx {
                deleteCSInfo = info
            } else {
                newCSInfos.append(info)
            }
        }
        
        csInfoArr.accept(newCSInfos)
        realmManager.deleteCSInfo(csInfoIdxArr: [deleteCSInfo!.csInfoIdx])
        
        if newCSInfos.isEmpty {
            deleteSplitAndRelatedData(splitIdx: deleteCSInfo!.splitIdx)
        }
    }
    
    /// csMemberIdx를 기준으로 csMember 삭제 및 연관 데이터 전체 삭제
    func deleteCSMemberAndRelatedData(csMemberIdx: String) {
        let realmManager = RealmManager()
        let csMembers: [CSMember] = csMemberArr.value
        var deleteCSMember: CSMember?
        var newCSMembers: [CSMember] = []
        
        for member in csMembers {
            if member.csMemberIdx == csMemberIdx {
                deleteCSMember = member
            } else {
                newCSMembers.append(member)
            }
        }
        
        if let deleteCSMember = deleteCSMember {
            csMemberArr.accept(newCSMembers)
            realmManager.deleteCSMember(csMemberIdxArr: [deleteCSMember.csInfoIdx])
            
            
            // 만약 csMember가 하나도 없다면 해당 csInfo 아래 모든 데이터 삭제
            if newCSMembers.isEmpty {
                deleteCSInfoAndRelatedData(csInfoIdx: deleteCSMember.csInfoIdx)
                
                // 아니라면 해당 csMember와 이름이 같은 해당 차수의 exclMember만 삭제
            } else {
                let csMemberName = deleteCSMember.name
                let csInfoIdx = deleteCSMember.csInfoIdx
                let exclMembers: [ExclMember] = exclMemberArr.value
                var deleteExclMembers: [ExclMember] = []
                var newExclMembers: [ExclMember] = []
                let exclItemIdxArr: [String] = exclItemArr.value.filter { $0.csInfoIdx == csInfoIdx }.map { $0.exclItemIdx }
                
                for member in exclMembers {
                    if member.name == csMemberName && exclItemIdxArr.contains(member.exclItemIdx) {
                        deleteExclMembers.append(member)
                    } else {
                        newExclMembers.append(member)
                    }
                }
                exclMemberArr.accept(newExclMembers)
                realmManager.deleteExclMember(exclMemberIdxArr: deleteExclMembers.map { $0.exclMemberIdx })
            }
        }
    }
    
    /// exclItemIdx를 기준으로 exclItem 삭제 및 연관 데이터 전체 삭제
    func deleteExclItemAndRelatedData(exclItemIdx: String) {
        let realmManager = RealmManager()
        let exclItems: [ExclItem] = exclItemArr.value
        var deleteExclItem: ExclItem?
        var newExclItems: [ExclItem] = []
        
        for item in exclItems {
            if item.exclItemIdx == exclItemIdx {
                deleteExclItem = item
            } else {
                newExclItems.append(item)
            }
        }
        
        exclItemArr.accept(newExclItems)
        realmManager.deleteExclItem(exclItemIdxArr: [deleteExclItem!.exclItemIdx])
        deleteExclMember(exclItemIdx: deleteExclItem!.exclItemIdx, realmManager: realmManager)
    }
    
    /// memberLogIdx로 memberLog 삭제
    func deleteMemberLog(memberLogIdx: String) {
        RealmManager().deleteMemberLog(memberLogIdx: memberLogIdx)
        self.fetchMemberLog()
    }
    
    /// 모든 realm의 데이터를 삭제 - Test 용
    func deleteAllDataToDB() {
        let realmManager = RealmManager()
        realmManager.deleteAllData()
    }
    
    /// splitIdx를 기준으로 csInfo 삭제
    private func deleteCSInfo(splitIdx: String, realmManager: RealmManager) -> [String] {
        let csInfos: [CSInfo] = csInfoArr.value
        var deleteCSInfos: [CSInfo] = []
        var newCSInfos: [CSInfo] = []
        
        for info in csInfos {
            if info.splitIdx == splitIdx {
                deleteCSInfos.append(info)
            } else {
                newCSInfos.append(info)
            }
        }
        
        csInfoArr.accept(newCSInfos)
        realmManager.deleteCSInfo(csInfoIdxArr: deleteCSInfos.map { $0.csInfoIdx })
        
        return deleteCSInfos.map { $0.csInfoIdx }
    }
    
    /// csInfoIdx를 기준으로 csMember 삭제
    private func deleteCSMember(csInfoIdxArr: [String], realmManager: RealmManager) {
        let csMembers: [CSMember] = csMemberArr.value
        var deleteCSMembers: [CSMember] = []
        var newCSMembers: [CSMember] = []
        
        for member in csMembers {
            if csInfoIdxArr.contains(member.csInfoIdx) {
                deleteCSMembers.append(member)
            } else {
                newCSMembers.append(member)
            }
        }
        
        csMemberArr.accept(newCSMembers)
        realmManager.deleteCSMember(csMemberIdxArr: deleteCSMembers.map { $0.csMemberIdx })
    }
    
    /// csInfoIdx를 기준으로 exclItem 삭제
    private func deleteExclItem(csInfoIdxArr: [String], realmManager: RealmManager) {
        let exclItems: [ExclItem] = exclItemArr.value
        var deleteExclItems: [ExclItem] = []
        var newExclItems: [ExclItem] = []
        
        for item in exclItems {
            if csInfoIdxArr.contains(item.csInfoIdx) {
                deleteExclItems.append(item)
                deleteExclMember(exclItemIdx: item.exclItemIdx, realmManager: realmManager)
            } else {
                newExclItems.append(item)
            }
        }
        
        exclItemArr.accept(newExclItems)
        realmManager.deleteExclItem(exclItemIdxArr: deleteExclItems.map { $0.exclItemIdx })
    }
    
    /// exclItem을 기준으로 exclMember 삭제
    private func deleteExclMember(exclItemIdx: String, realmManager: RealmManager) {
        let exclMembers: [ExclMember] = exclMemberArr.value
        var deleteExclMembers: [ExclMember] = []
        var newExclMembers: [ExclMember] = []
        
        for member in exclMembers {
            if member.exclItemIdx == exclItemIdx {
                deleteExclMembers.append(member)
            } else {
                newExclMembers.append(member)
            }
        }
        
        exclMemberArr.accept(newExclMembers)
        realmManager.deleteExclMember(exclMemberIdxArr: deleteExclMembers.map { $0.exclMemberIdx })
    }
}

extension SplitRepository {
    
    /// 각 ExclMember의 isTarget 토글
    func toggleExclMember(exclMemberIdx: String) {
        var exclMembers: [ExclMember] = exclMemberArr.value
        
        for i in 0...exclMembers.count-1 {
            if exclMembers[i].exclMemberIdx == exclMemberIdx {
                exclMembers[i].isTarget.toggle()
            }
        }
        
        exclMemberArr.accept(exclMembers)
    }
    
    /// Arr들을 DB에 업데이트
    func updateDataToDB() {
        let realmManager = RealmManager()
        
        editSplitCreateDate()
        
        let splitArr = splitArr.value
        realmManager.updateData(splitArr: splitArr)
        
        let csInfoArr = csInfoArr.value
        realmManager.updateData(csInfoArr: csInfoArr)
        
        let csMemberArr = csMemberArr.value
        realmManager.updateData(csMemberArr: csMemberArr)
        
        let exclItemArr = exclItemArr.value
        realmManager.updateData(exclItemArr: exclItemArr)
        
        let exclMemberArr = exclMemberArr.value
        realmManager.updateData(exclMemberArr: exclMemberArr)
    }
}

//extension SplitRepository {
//    func createExclItemPrice(price: Int) {
//        
//    }
//}


func createDummy() {
    let repo = SplitRepository.share
    
    repo.createDatasForCreateFlow()
    repo.inputCSInfoWithTitle(title: "Test")
    repo.inputCSInfoWithTotalAmount(totalAmount: 1000)
    repo.createCSMember(name: "제롬")
    repo.createCSMember(name: "완")
    repo.createCSMember(name: "모아나")
    repo.createCSMember(name: "제리")
    repo.createCSMember(name: "토마토")
    repo.createCSMember(name: "코리")
    repo.createExclItemWithName(name: "맥주")
    repo.inputExclItemPrice(price: 100)
    repo.updateDataToDB()
}

