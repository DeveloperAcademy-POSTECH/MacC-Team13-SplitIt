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
    
    /// Realm에 Data 저장 및 업데이트
    func updateData<T: RealmRepresentable>(arr: [T]) {
        do {
            let realm = try Realm()
            
            arr.forEach { object in
                let rmObject = object.asRealm() as! Object
                
                print(rmObject)
                
                try! realm.write {
                    realm.add(rmObject, update: .all)
                }
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
    
    /// Realm에서 Data 삭제
    func deleteDatas<T: Object & LocalConvertibleType>(deleteType: T.Type, idxArr: [String]) {
        do {
            let realm = try Realm()
            let idxArr = idxArr.map { try! ObjectId(string: $0) }
            
            idxArr.forEach { idx in
                if let deleteData = realm.object(ofType: T.self, forPrimaryKey: idx) {
                    try! realm.write {
                        realm.delete(deleteData)
                    }
                }
            }
        } catch {
            print("DeleteDate To Realm Error")
        }
    }
    
    /// Realm에서 모든 memberLog를 삭제
    func deleteAllMemberLog() {
        do {
            let realm = try Realm()
            
            let memberLogs = realm.objects(RMMemberLog.self)
            
            try! realm.write {
                realm.delete(memberLogs)
            }
            
        } catch {
            print("DeleteAllMemberLog To Realm Error")
        }
    }

    /// Realm에서 최근 날짜 기준으로 갯수만큼 Split 가져오기
    func bringSplitWithCount(bringCount: Int) -> [Split] {
        do {
            let realm = try Realm()
            let realmSplitArr = realm.objects(RMSplit.self)
            
            if realmSplitArr.isEmpty {
                return []
            } else {
                let count = realmSplitArr.count >= bringCount ? bringCount-1 : realmSplitArr.count-1
                let realmSplitSorted = realmSplitArr.sorted(byKeyPath: "createDate", ascending: false)[0...count]
                let transformSplits: [Split] = realmSplitSorted.map { $0.asLocal() }
                
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
            let realmCSInfoArr = realm.objects(RMCSInfo.self).where { $0.splitIdx.in(splitIdxArr) }
            let transformCSInfos: [CSInfo] = realmCSInfoArr.map { $0.asLocal() }
            
            return transformCSInfos
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 CSInfo들을 기준으로 CSMember 가져오기
    func bringCSMemberWithCSInfoIdxArr(csInfoIdxArr: [String]) -> [CSMember] {
        do {
            let realm = try Realm()
            let realmCSMemberArr = realm.objects(RMCSMember.self).where { $0.csInfoIdx.in(csInfoIdxArr) }
            let transformCSMembers: [CSMember] = realmCSMemberArr.map { $0.asLocal() }
            
            return transformCSMembers
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 CSInfo들을 기준으로 ExclItem 가져오기
    func bringExclItemWithCSInfoIdxArr(csInfoIdxArr: [String]) -> [ExclItem] {
        do {
            let realm = try Realm()
            let realmExclItemArr = realm.objects(RMExclItem.self).where { $0.csInfoIdx.in(csInfoIdxArr) }
            let transformExclItems: [ExclItem] = realmExclItemArr.map { $0.asLocal() }
            
            return transformExclItems
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
    
    /// Realm에서 ExclItem들을 기준으로 ExclMember 가져오기
    func bringExclMemberWithExclItemIdxArr(exclItemIdxArr: [String]) -> [ExclMember] {
        do {
            let realm = try Realm()
            let realmExclMemberArr = realm.objects(RMExclMember.self).where { $0.exclItemIdx.in(exclItemIdxArr) }
            let transformExclMembers: [ExclMember] = realmExclMemberArr.map { $0.asLocal() }
            
            return transformExclMembers
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
            let realmSplitArr = realm.objects(RMSplit.self).where { $0.splitIdx == idx }
            
            if realmSplitArr.count == 1 {
                let transformSplits: [Split] = realmSplitArr.map { $0.asLocal() }
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
            let realmCSInfoArr = realm.objects(RMCSInfo.self).where { $0.csInfoIdx == idx }
            
            if realmCSInfoArr.count == 1 {
                let transformCSInfos: [CSInfo] = realmCSInfoArr.map { $0.asLocal() }
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
            let realmMemberLogArr = realm.objects(RMMemberLog.self)
            return realmMemberLogArr.map { $0.asLocal() }
        } catch {
            print("UpdateDate To Realm Error")
            return []
        }
    }
}
