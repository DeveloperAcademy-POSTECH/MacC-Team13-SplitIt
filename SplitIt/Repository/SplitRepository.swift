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
    
    private(set) var splitArr = BehaviorRelay<[Split]>(value: [])
    private(set) var csInfoArr = BehaviorRelay<[CSInfo]>(value: [])
    private(set) var exclItemArr = BehaviorRelay<[ExclItem]>(value: [])
    private(set) var exclMemberArr = BehaviorRelay<[ExclMember]>(value: [])
    private(set) var csMemberArr = BehaviorRelay<[CSMember]>(value: [])
    private(set) var memberLogArr = BehaviorRelay<[MemberLog]>(value: [])
    
    private init() { }
    
    var isSmartSplit = true
    var isCreate = true

    /// DB에서 날짜를 기준으로 20개의 split만 필터링해서 하위 모든 Arr 패치
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
    
    /// csInfoIdx가 일치하는 csInfo만 필터링해서 하위 모든 Arr 패치
    func fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: String) {
        let realmManager = RealmManager()
        csInfoArr.accept(realmManager.bringCSInfoWithCSInfoIdx(csInfoIdx: csInfoIdx))
        
        guard let split = csInfoArr.value.first else { return }
        let splitIdx = split.splitIdx
        splitArr.accept(realmManager.bringSplitWithSplitIdx(splitIdx: splitIdx))
        
        fetchAllDataBaseSplit(true, realmManager: realmManager)
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

    /// 새로운 split, csInfo, csMember(default: 나) 생성 => MainView에서 split it 버튼 클릭시 호출되도록 설정
    func createDatasForCreateFlow() {
        let newSplit = Split()
        let newCSInfo = CSInfo(title: "1차", splitIdx: newSplit.splitIdx)
        let newCSMember = CSMember(name: "정산자", csInfoIdx: newCSInfo.csInfoIdx)
        
        splitArr.accept([newSplit])
        csInfoArr.accept([newCSInfo])
        csMemberArr.accept([newCSMember])
        exclItemArr.accept([])
        exclMemberArr.accept([])
    }
    
    /// 이름 배열을 받아와서 csMember 생성
    func createCSMemberArr(nameArr: [String]) {
        let currentCSInfoIdx = csInfoArr.value.first!.csInfoIdx
        let newCSMembers = nameArr.map { CSMember(name: $0, csInfoIdx: currentCSInfoIdx)}
        csMemberArr.accept(newCSMembers)
    }
    
    /// CSInfoIdx, name으로 ExclItem 생성
    func createExclItem(name: String, price: Int, exclMember: [ExclItemTable]) {
        let currentCSInfoIdx = csInfoArr.value.first!.csInfoIdx
        let newExclItem: ExclItem = ExclItem(name: name, price: price, csInfoIdx: currentCSInfoIdx)
        var preExclItemArr: [ExclItem] = exclItemArr.value
        preExclItemArr.append(newExclItem)
        exclItemArr.accept(preExclItemArr)
        
        var currentExclMemberArr = exclMemberArr.value
       
        for item in exclMember {
            let newExclMember = ExclMember(name: item.name, isTarget: item.isTarget, exclItemIdx: newExclItem.exclItemIdx)
            
            currentExclMemberArr.append(newExclMember)
        }
        
        exclMemberArr.accept(currentExclMemberArr)
    }
    
    /// 현재 splitIdx를 기준으로 CSInfo부터 아래 데이터들만 새로 생성
    func createNewCS() {
        let currentCSInfoCount = getCurrentSplitCSInfoCount()
        
        let splitIdx = splitArr.value.first!.splitIdx
        let preCSInfo = csInfoArr.value.last!.csInfoIdx
        let preCSMember = csMemberArr.value.filter { $0.csInfoIdx == preCSInfo }
        let newCSInfo = CSInfo(title: "\(currentCSInfoCount + 1)차", splitIdx: splitIdx)
        var newCSMembers: [CSMember] = []
        
        preCSMember.forEach {
            let newCSMember = CSMember(name: $0.name, csInfoIdx: newCSInfo.csInfoIdx)
            newCSMembers.append(newCSMember)
        }
        
        csInfoArr.accept([newCSInfo])
        csMemberArr.accept(newCSMembers)
        exclItemArr.accept([])
        exclMemberArr.accept([])
    }
    
    /// name을 받아서 memberLogArr, realm에 새로 생성
    func createMemberLog(name: String) {
        RealmManager().updateData(arr: [MemberLog(name: name)])
    }

    /// 현재 csInfo의 정보 변경하기
    func inputCSInfoDatas(title: String, totalAmount: Int) {
        var currentCSInfo = csInfoArr.value.first!
        currentCSInfo.title = title
        currentCSInfo.totalAmount = totalAmount
        csInfoArr.accept([currentCSInfo])
    }

    // TODO: - 현재 split의 title을 수정 => 지금은 사용하는데 없는데 디자인이랑 말해서 정산 이름 바꾸는 뷰 안만들거면 삭제할 것
    func editSplitTitle(title: String) {
        let realmManager = RealmManager()
        
        let splits: [Split] = splitArr.value
        var split: Split = splits.first!
        split.title = title
        split.createDate = Date.now
        splitArr.accept([split])
        realmManager.updateData(arr: [split])
    }
    
    // TODO: - EditCSInfo에서 이 메서드로 바꿀 것
    func editCSInfo(title: String, totalAmount: Int) {
        let realmManager = RealmManager()
        
        let csInfos: [CSInfo] = csInfoArr.value
        var csInfo: CSInfo = csInfos.first!
        csInfo.title = title
        csInfo.totalAmount = totalAmount
        csInfoArr.accept([csInfo])
        editSplitCreateDate()
        
        realmManager.updateData(arr: [csInfo])
    }
    
    // TODO: - 아래 2개 EditCSInfo에서 빼고 삭제할 것
    /// csInfo 이름 수정 - 수정 시 바로 realm에도 반영
    func editCSInfoTitle(title: String) {
        let realmManager = RealmManager()
        
        let csInfos: [CSInfo] = csInfoArr.value
        var csInfo: CSInfo = csInfos.first!
        csInfo.title = title
        csInfoArr.accept([csInfo])
        
        realmManager.updateData(arr: [csInfo])
    }
    
    /// csInfo 가격 수정 - 수정 시 바로 realm에도 반영
    func editCSInfoTotalAcount(totalAcount: Int) {
        let realmManager = RealmManager()
        
        let csInfos: [CSInfo] = csInfoArr.value
        var csInfo: CSInfo = csInfos.first!
        csInfo.totalAmount = totalAcount
        csInfoArr.accept([csInfo])
        
        realmManager.updateData(arr: [csInfo])
    }
    
    // TODO: - EditExclItem에서 이 메서드로 바꿀 것
    func editExclItem(exclItemIdx: String, name: String, price: Int) {
        var exclItems: [ExclItem] = exclItemArr.value
        let exclItemIdxArr: [String] = exclItems.map { $0.exclItemIdx }
        
        if let index = exclItemIdxArr.firstIndex(of: exclItemIdx) {
            exclItems[index].name = name
            exclItems[index].price = price
        }
        
        exclItemArr.accept(exclItems)
    }
    
    // TODO: - 아래 2개 합쳐서 EditExclItem에서 바꿀 것
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
    
    /// csMember를 바꿨을 때 exclMember에도 자동 반영
    func editCSMemberAndExclMember() {
        let realm = RealmManager()
        let currentCSInfoIdx = csMemberArr.value.first!.csInfoIdx
        let realmCurrentCSMemberIdxArr = realm.bringCSMemberWithCSInfoIdxArr(csInfoIdxArr: [currentCSInfoIdx]).map { $0.csMemberIdx }
        let exclItemIdxArr = exclItemArr.value.map { $0.exclItemIdx }
        let realmCurrentExclMemberIdxArr = realm.bringExclMemberWithExclItemIdxArr(exclItemIdxArr: exclItemIdxArr).map { $0.exclMemberIdx }
        
        var nameAndIsTargetHash: [String: Bool] = [:]
        
        exclMemberArr.value.forEach {
            nameAndIsTargetHash.updateValue($0.isTarget, forKey: $0.name)
        }
        
        realm.deleteDatas(deleteType: RMCSMember.self, idxArr: realmCurrentCSMemberIdxArr)
        realm.deleteDatas(deleteType: RMExclMember.self, idxArr: realmCurrentExclMemberIdxArr)
        
        realm.updateData(arr: csMemberArr.value)
        
        var newExclMembers: [ExclMember] = []
        
        for itemIdx in exclItemIdxArr {
            for csMember in csMemberArr.value {
                newExclMembers.append(ExclMember(name: csMember.name, isTarget: nameAndIsTargetHash[csMember.name] ?? false, exclItemIdx: itemIdx))
            }
        }
        
        realm.updateData(arr: newExclMembers)
    }
    
    /// split의 createDate를 현재시간으로 수정
    private func editSplitCreateDate() {
        let splits: [Split] = splitArr.value
        var split: Split = splits.first!
        split.createDate = Date.now
        splitArr.accept([split])
    }
    
    /// csInfoIdx를 기준으로 csInfo 삭제 및 연관 데이터 전체 삭제
    func deleteCSInfoAndRelatedData(csInfoIdx: String) {
        let realmManager = RealmManager()
        let deleteCSInfo: [CSInfo] = csInfoArr.value
        
        realmManager.deleteDatas(deleteType: RMCSInfo.self, idxArr: [deleteCSInfo.first!.csInfoIdx])
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
        realmManager.deleteDatas(deleteType: RMExclItem.self, idxArr: [deleteExclItem!.exclItemIdx])
        deleteExclMember(exclItemIdx: deleteExclItem!.exclItemIdx, realmManager: realmManager)
    }
    
    /// ExclItemInput뷰가 disAppear 될 때 초기화
    func deleteCurrentExclItemAndExclMember() {
        self.exclItemArr.accept([])
        self.exclMemberArr.accept([])
    }
    
    /// memberLogIdx로 memberLog 삭제
    func deleteMemberLog(memberLogIdx: String) {
        RealmManager().deleteDatas(deleteType: RMMemberLog.self, idxArr: [memberLogIdx])
        self.fetchMemberLog()
    }
    
    func deleteAllMemberLog() {
        RealmManager().deleteAllMemberLog()
        self.memberLogArr.accept([])
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
        realmManager.deleteDatas(deleteType: RMExclMember.self, idxArr: deleteExclMembers.map { $0.exclMemberIdx })
    }
    
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
    
    /// 현재 Split에 CSInfo가 몇 개 있는지 Count
    private func getCurrentSplitCSInfoCount() -> Int {
        return RealmManager().bringCSInfoWithSplitIdxArr(splitIdxArr: [splitArr.value.first!.splitIdx]).count
    }
    
    /// Arr들을 DB에 업데이트
    func updateDataToDB() {
        let realmManager = RealmManager()
        
        editSplitCreateDate()
        realmManager.updateData(arr: splitArr.value)
        realmManager.updateData(arr: csInfoArr.value)
        realmManager.updateData(arr: csMemberArr.value)
        realmManager.updateData(arr: exclItemArr.value)
        realmManager.updateData(arr: exclMemberArr.value)
    }
}
