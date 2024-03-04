//
//  CreateService.swift
//  SplitIt
//
//  Created by Zerom on 1/11/24.
//

import RxCocoa
import RxSwift
import Foundation

protocol CreateServiceType {
    var split: Split { get }
    var csInfo: CSInfo { get }
    var csMemberArr: [CSMember] { get }
    var exclItemRelay: BehaviorRelay<[ExclItem]> { get }
    var exclMemberRelay: BehaviorRelay<[ExclMember]> { get }
    
    func createCSMembers(names: [String])
    func inputCSInfoDatas(title: String, totalAmount: Int)
    func createExclItem(name: String, price: Int, exclMember: [ExclItemTable])
    func editExclItem(exclItemIdx: String, name: String, price: Int)
    func deleteExcls()
    func toggleExclMember(exclMemberIdx: String)
    func saveNewSplit()
}

final class CreateService: CreateServiceType {
    
    private var manager: CreateRealmManagerType
    var currentSplitIdx: String
    
    private(set) var split: Split = Split()
    private(set) var csInfo: CSInfo = CSInfo(title: "", splitIdx: "")
    private(set) var csMemberArr: [CSMember] = []
    private(set) var exclItemRelay = BehaviorRelay<[ExclItem]>(value: [])
    private(set) var exclMemberRelay = BehaviorRelay<[ExclMember]>(value: [])
    
    init(currentSplitIdx: String, 
         createRealmManager: CreateRealmManagerType
    ) {
        self.manager = createRealmManager
        self.currentSplitIdx = currentSplitIdx
        
        currentSplitIdx == "" ? self.createNewSplit() : self.createNewCS(currentSplitIdx: currentSplitIdx)
    }
    
    func inputCSInfoDatas(title: String, totalAmount: Int) {
        csInfo.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        csInfo.totalAmount = totalAmount
    }
    
    func createCSMembers(names: [String]) {
        let currentCSInfoIdx = csInfo.csInfoIdx
        let csMembers = names.map({
            CSMember(name: $0.trimmingCharacters(in: .whitespacesAndNewlines), csInfoIdx: currentCSInfoIdx)
        })
        
        csMemberArr = csMembers
    }
    
    func createExclItem(name: String, price: Int, exclMember: [ExclItemTable]) {
        let currentCSInfoIdx = csInfo.csInfoIdx
        var exclItems = exclItemRelay.value
        let newExclItem: ExclItem = ExclItem(name: name.trimmingCharacters(in: .whitespacesAndNewlines), price: price, csInfoIdx: currentCSInfoIdx)
        exclItems.append(newExclItem)
        exclItemRelay.accept(exclItems)
        
        var exclMembers = exclMemberRelay.value
        
        for item in exclMember {
            let newExclMember = ExclMember(name: item.name.trimmingCharacters(in: .whitespacesAndNewlines), isTarget: item.isTarget, exclItemIdx: newExclItem.exclItemIdx)
            
            exclMembers.append(newExclMember)
        }
        
        exclMemberRelay.accept(exclMembers)
    }
    
    func editExclItem(exclItemIdx: String, name: String, price: Int) {
        var exclItems: [ExclItem] = exclItemRelay.value
        
        for i in 0..<exclItems.count {
            if exclItems[i].exclItemIdx == exclItemIdx {
                exclItems[i].name = name
                exclItems[i].price = price
            }
        }
        
        exclItemRelay.accept(exclItems)
    }
    
    func deleteExcls() {
        self.exclItemRelay.accept([])
        self.exclMemberRelay.accept([])
    }
    
    func toggleExclMember(exclMemberIdx: String) {
        var exclMembers: [ExclMember] = exclMemberRelay.value
        
        for i in 0...exclMembers.count-1 {
            if exclMembers[i].exclMemberIdx == exclMemberIdx {
                exclMembers[i].isTarget.toggle()
            }
        }
        
        exclMemberRelay.accept(exclMembers)
    }
    
    func saveNewSplit() {
        self.manager.updateData(arr: [self.split.asRealm()])
        self.manager.updateData(arr: [self.csInfo.asRealm()])
        self.manager.updateData(arr: self.csMemberArr.map { $0.asRealm() })
        self.manager.updateData(arr: self.exclItemRelay.value.map { $0.asRealm() })
        self.manager.updateData(arr: self.exclMemberRelay.value.map { $0.asRealm() })
    }
    
    private func createNewSplit() {
        self.split = Split()
        self.csInfo = CSInfo(title: "1차", splitIdx: self.split.splitIdx)
        self.csMemberArr.append(CSMember(name: "정산자", csInfoIdx: self.csInfo.csInfoIdx))
    }
    
    private func createNewCS(currentSplitIdx: String) {
        if let split = getCurrentSplit(currentSplitIdx: currentSplitIdx) {
            self.split = split
        }
        
        let currentCSInfoCount = getCurrentSplitCSInfoCount()
        self.csInfo = CSInfo(title: "\(currentCSInfoCount + 1)차", splitIdx: self.split.splitIdx)
        
        self.csMemberArr = getPreCSInfosCSMemberAndChangeCurrentCSIdx(currentSplitIdx: currentSplitIdx)
    }
    
    private func getCurrentSplitCSInfoCount() -> Int {
        return try! manager.getCSInfoCount(currentSplitIdx: self.currentSplitIdx)
    }
    
    private func getCurrentSplit(currentSplitIdx: String) -> Split? {
        if let rmSplit = try? manager.getCurrentSplit(currentSplitIdx: currentSplitIdx) {
            return rmSplit.asLocal()
        } else {
            return nil
        }
    }
    
    private func getPreCSInfosCSMemberAndChangeCurrentCSIdx(currentSplitIdx: String) -> [CSMember] {
        return try! manager.getPreCSMembers(currentSplitIdx: currentSplitIdx).map { $0.asLocal() }
    }
}

class StubCreateService: CreateServiceType {
    
    var split: Split = Split()
    var csInfo: CSInfo = CSInfo(title: "", splitIdx: "")
    var csMemberArr: [CSMember] = []
    var exclItemRelay = BehaviorRelay<[ExclItem]>(value: [])
    var exclMemberRelay = BehaviorRelay<[ExclMember]>(value: [])
    
    func createCSMembers(names: [String]) {
        
    }
    
    func inputCSInfoDatas(title: String, totalAmount: Int) {
        
    }
    
    func createExclItem(name: String, price: Int, exclMember: [ExclItemTable]) {
        
    }
    
    func editExclItem(exclItemIdx: String, name: String, price: Int) {
        
    }
    
    func deleteExcls() {
        
    }
    
    func toggleExclMember(exclMemberIdx: String) {
        
    }
    
    func saveNewSplit() {
        
    }
}
