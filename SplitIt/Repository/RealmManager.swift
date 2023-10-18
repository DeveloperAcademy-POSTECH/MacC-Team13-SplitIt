//
//  RealmManager.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

final class RealmManager {
    
    /// Realm에 Split 업데이트
    func updateData(splitArr: [Split]) {
        do {
            let realm = try Realm()
            
            splitArr.forEach { split in
                let realmSplit = RealmSplit()
                realmSplit.update(withSplit: split)
                
                try! realm.write {
                    realm.add(realmSplit, update: .all)
                }
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
    
    /// Realm에 CSInfo 업데이트
    func updateData(csInfoArr: [CSInfo]) {
        do {
            let realm = try Realm()
            
            csInfoArr.forEach { csInfo in
                let realmCSInfo = RealmCSInfo()
                realmCSInfo.update(withCSInfo: csInfo)
                
                try! realm.write {
                    realm.add(realmCSInfo, update: .all)
                }
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
    
    /// Realm에 CSMember 업데이트
    func updateData(csMemberArr: [CSMember]) {
        do {
            let realm = try Realm()
            
            csMemberArr.forEach { csMember in
                let realmCSMember = RealmCSMember()
                realmCSMember.update(withCSMember: csMember)
                
                try! realm.write {
                    realm.add(realmCSMember, update: .all)
                }
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
    
    /// Realm에 ExclItem 업데이트
    func updateData(exclItemArr: [ExclItem]) {
        do {
            let realm = try Realm()
            
            exclItemArr.forEach { exclItem in
                let realmExclItem = RealmExclItem()
                realmExclItem.update(withExclItem: exclItem)
                
                try! realm.write {
                    realm.add(realmExclItem, update: .all)
                }
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
    
    /// Realm에 ExclMember 업데이트
    func updateData(exclMemberArr: [ExclMember]) {
        do {
            let realm = try Realm()
            
            exclMemberArr.forEach { exclMember in
                let realmExclMember = RealmExclMember()
                realmExclMember.update(withExclMember: exclMember)
                
                try! realm.write {
                    realm.add(realmExclMember, update: .all)
                }
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
    
    /// Realm에 MemberLog 업데이트
    func updateData(memberLog: MemberLog) {
        do {
            let realm = try Realm()
            let realmMemberLog = RealmMemberLog()
            realmMemberLog.update(withMemerLog: memberLog)
            
            try! realm.write {
                realm.add(realmMemberLog)
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
}

extension RealmManager {
    
    /// Realm에서 최근 날짜 기준으로 갯수만큼 Split 가져오기
    func bringSplitWithCount(bringCount: Int) -> [Split] {
        do {
            let realm = try Realm()
            let realmSplitArr = realm.objects(RealmSplit.self)
            
            if realmSplitArr.count == 0 {
                return []
            } else {
                let count = realmSplitArr.count >= bringCount ? bringCount-1 : realmSplitArr.count-1
                let realmSplitSorted = realmSplitArr.sorted(byKeyPath: "createDate", ascending: false)[0...count]
                let transformSplits: [Split] = realmSplitSorted.map { Split(withRealmSplit: $0) }
                
                print("Split fetch 완료")
                return transformSplits
            }
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 splitIdx를 기준으로 CSInfo 가져오기
    func bringCSInfoWithSplitIdxArr(splitIdxArr: [String]) -> [CSInfo] {
        do {
            let realm = try Realm()
            let realmCSInfoArr = realm.objects(RealmCSInfo.self).where { $0.splitIdx.in(splitIdxArr) }
            
            if realmCSInfoArr.count == 0 {
                return []
            } else {
                let transformCSInfos: [CSInfo] = realmCSInfoArr.map { CSInfo(withRealmCSInfo: $0) }
                
                print("CSInfo fetch 완료")
                return transformCSInfos
            }
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 CSInfo들을 기준으로 CSMember 가져오기
    func bringCSMemberWithCSInfoIdxArr(csInfoIdxArr: [String]) -> [CSMember] {
        do {
            let realm = try Realm()
            let realmCSMemberArr = realm.objects(RealmCSMember.self).where { $0.csInfoIdx.in(csInfoIdxArr) }
            
            if realmCSMemberArr.count == 0 {
                return []
            } else {
                let transformCSMembers: [CSMember] = realmCSMemberArr.map { CSMember(withRealmCSMember: $0) }
                
                print("CSInfo fetch 완료")
                return transformCSMembers
            }
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 CSInfo들을 기준으로 ExclItem 가져오기
    func bringExclItemWithCSInfoIdxArr(csInfoIdxArr: [String]) -> [ExclItem] {
        do {
            let realm = try Realm()
            let realmExclItemArr = realm.objects(RealmExclItem.self).where { $0.csInfoIdx.in(csInfoIdxArr) }
            
            if realmExclItemArr.count == 0 {
                return []
            } else {
                let transformExclItems: [ExclItem] = realmExclItemArr.map { ExclItem(withRealmExclItem: $0) }
                
                print("CSInfo fetch 완료")
                return transformExclItems
            }
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 ExclItem들을 기준으로 ExclMember 가져오기
    func bringExclMemberWithExclItemIdxArr(exclItemIdxArr: [String]) -> [ExclMember] {
        do {
            let realm = try Realm()
            let realmExclMemberArr = realm.objects(RealmExclMember.self).where { $0.exclItemIdx.in(exclItemIdxArr) }
            
            if realmExclMemberArr.count == 0 {
                return []
            } else {
                let transformExclMembers: [ExclMember] = realmExclMemberArr.map { ExclMember(withRealmExclMember: $0) }
                
                print("CSInfo fetch 완료")
                return transformExclMembers
            }
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 SplitIdx를 기준으로 Split 가져오기 - 해당하는 Split 하나만 배열형태로 가져오게됨
    func bringSplitWithSplitIdx(splitIdx: String) -> [Split] {
        do {
            let realm = try Realm()
            let idx = try! ObjectId(string: splitIdx)
            let realmSplitArr = realm.objects(RealmSplit.self).where { $0.splitIdx == idx }
            
            if realmSplitArr.count == 1 {
                let transformSplits: [Split] = realmSplitArr.map { Split(withRealmSplit: $0) }
                return transformSplits
            }
            
            return []
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 CSInfoIdx를 기준으로 CSInfo 가저오기 - 해당하는 CSInfo 하나만 배열형태로 가져오게됨
    func bringCSInfoWithCSInfoIdx(csInfoIdx: String) -> [CSInfo] {
        do {
            let realm = try Realm()
            let idx = try! ObjectId(string: csInfoIdx)
            let realmCSInfoArr = realm.objects(RealmCSInfo.self).where { $0.csInfoIdx == idx }
            
            if realmCSInfoArr.count == 1 {
                let transformCSInfos: [CSInfo] = realmCSInfoArr.map { CSInfo(withRealmCSInfo: $0) }
                return transformCSInfos
            }
            
            return []
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 memberLog 전체를 가져오기
    func bringMemberLogAll() -> [MemberLog] {
        do {
            let realm = try Realm()
            let realmMemberLogArr = realm.objects(RealmMemberLog.self)
            
            return realmMemberLogArr.map { MemberLog(withRealmMemberLog: $0) }
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
}

extension RealmManager {
    
    /// splitIdx를 기준으로 split을 삭제하는 메서드
    func deleteSplit(splitIdx: String) {
        do {
            let realm = try Realm()
            
            let idx = try! ObjectId(string: splitIdx)
            let deleteSplit = realm.objects(RealmSplit.self).where { $0.splitIdx == idx }
            
            try! realm.write {
                realm.delete(deleteSplit)
            }

        } catch {
            print("DeleteDate To Realm Error")
        }
    }
    
    /// [csInfo]를 기준으로 csInfo를 삭제하는 메서드
    func deleteCSInfo(csInfoIdxArr: [String]) {
        do {
            let realm = try Realm()
            
            let idxArr = csInfoIdxArr.map { try! ObjectId(string: $0) }
            let deleteCSInfoArr = realm.objects(RealmCSInfo.self).where { $0.csInfoIdx.in(idxArr) }

            deleteCSInfoArr.forEach { csInfo in
                try! realm.write {
                    realm.delete(csInfo)
                }
            }
        } catch {
            print("DeleteDate To Realm Error")
        }
    }
    
    /// [csMemberIdx]를 기준으로 csMember를 삭제하는 메서드
    func deleteCSMember(csMemberIdxArr: [String]) {
        do {
            let realm = try Realm()
            
            let idxArr = csMemberIdxArr.map { try! ObjectId(string: $0) }
            let deleteCSMemberArr = realm.objects(RealmCSMember.self).where { $0.csMemberIdx.in(idxArr) }

            deleteCSMemberArr.forEach { csMember in
                try! realm.write {
                    realm.delete(csMember)
                }
            }
        } catch {
            print("DeleteDate To Realm Error")
        }
    }
    
    /// [exclItemIdx]를 기준으로 exclItem을 삭제하는 메서드
    func deleteExclItem(exclItemIdxArr: [String]) {
        do {
            let realm = try Realm()
            
            let idxArr = exclItemIdxArr.map { try! ObjectId(string: $0) }
            let deleteExclItemArr = realm.objects(RealmExclItem.self).where { $0.exclItemIdx.in(idxArr) }

            deleteExclItemArr.forEach { exclItem in
                try! realm.write {
                    realm.delete(exclItem)
                }
            }
        } catch {
            print("DeleteDate To Realm Error")
        }
    }
    
    /// [exclMemberIdx]를 기준으로 exclMember를 삭제하는 메서드
    func deleteExclMember(exclMemberIdxArr: [String]) {
        do {
            let realm = try Realm()
            
            let idxArr = exclMemberIdxArr.map { try! ObjectId(string: $0) }
            let deleteExclMemberArr = realm.objects(RealmExclMember.self).where { $0.exclMemberIdx.in(idxArr) }

            deleteExclMemberArr.forEach { exclMember in
                try! realm.write {
                    realm.delete(exclMember)
                }
            }
        } catch {
            print("DeleteDate To Realm Error")
        }
    }
    
    /// memberLog name을 기준으로 memberLog를 삭제하는 메서드
    func deleteMemberLog(memberLogIdx: String) {
        do {
            let realm = try Realm()
            
            let memberLogIdx = try! ObjectId(string: memberLogIdx)
            let deleteMemberLog = realm.objects(RealmMemberLog.self).where { $0.memberLogIdx == memberLogIdx }
            
            try! realm.write {
                realm.delete(deleteMemberLog)
            }

        } catch {
            print("DeleteDate To Realm Error")
        }
    }
    
    /// 전체 realmData 삭제 -> 테스트용
    func deleteAllData() {
        do {
            let realm = try Realm()
            
            try! realm.write {
                realm.deleteAll()
            }
            
            print("Realm fetch 완료")
            
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
}


//extension RealmManager {
//    func createDummy() {
//            let repo = Repository.shard
//
//            repo.createDatasForCreateFlow()
//            repo.inputCSInfoWithTitle(title: "Test")
//            repo.inputCSInfoWithTotalAmount(totalAmount: 1000)
//            repo.createCSMember(name: "제롬")
//            repo.createCSMember(name: "완")
//            repo.createCSMember(name: "모아나")
//            repo.createCSMember(name: "제리")
//            repo.createCSMember(name: "토마토")
//            repo.createCSMember(name: "코리")
//            repo.createExclItemWithName(name: "맥주")
//            repo.createExclItemPrice(price: 100)
//            repo.updateDataToDB()
//        }
//}
