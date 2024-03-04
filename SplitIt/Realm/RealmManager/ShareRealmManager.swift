//
//  ShareManager.swift
//  SplitIt
//
//  Created by Zerom on 1/12/24.
//

import Foundation
import RealmSwift

enum ShareRealmError: Error {
    case notFoundSplit
    case failBringSplit
    case failBringCSInfos
    case failBringCSMembers
    case failBringExclItems
    case failBringExclMembers
}

protocol ShareRealmManagerType {
    func getSplitWithSplitIdx(splitIdx: String) throws -> RMSplit
    func getCSInfoWithSplitIdxArr(splitIdx: String) throws -> [RMCSInfo]
    func getCSMemberWithCSInfoIdxArr(csInfoIdxArr: [String]) throws -> [RMCSMember]
    func getExclItemWithCSInfoIdxArr(csInfoIdxArr: [String]) throws -> [RMExclItem]
    func getExclMemberWithExclItemIdxArr(exclItemIdxArr: [String]) throws -> [RMExclMember]
}

class ShareRealmManager: ShareRealmManagerType {
    
    func getSplitWithSplitIdx(splitIdx: String) throws -> RMSplit {
        do {
            let realm = try Realm()
            guard let idx = try? ObjectId(string: splitIdx) else { throw ShareRealmError.notFoundSplit }
            let realmSplit = realm.objects(RMSplit.self).where { $0.splitIdx == idx }
            if let rmSplit = realmSplit.first {
                return rmSplit
            } else {
                throw ShareRealmError.notFoundSplit
            }
        } catch {
            throw ShareRealmError.failBringSplit
        }
    }
    
    func getCSInfoWithSplitIdxArr(splitIdx: String) throws -> [RMCSInfo] {
        do {
            let realm = try Realm()
            let realmCSInfoArr = realm.objects(RMCSInfo.self).where { $0.splitIdx == splitIdx }
            
            return realmCSInfoArr.map { $0 }
        } catch {
            throw ShareRealmError.failBringCSInfos
        }
    }
    
    func getCSMemberWithCSInfoIdxArr(csInfoIdxArr: [String]) throws -> [RMCSMember] {
        do {
            let realm = try Realm()
            let realmCSMemberArr = realm.objects(RMCSMember.self).where { $0.csInfoIdx.in(csInfoIdxArr) }
            
            return realmCSMemberArr.map { $0 }
        } catch {
            throw ShareRealmError.failBringCSMembers
        }
    }
    
    func getExclItemWithCSInfoIdxArr(csInfoIdxArr: [String]) throws -> [RMExclItem] {
        do {
            let realm = try Realm()
            let realmExclItemArr = realm.objects(RMExclItem.self).where { $0.csInfoIdx.in(csInfoIdxArr) }
            
            return realmExclItemArr.map { $0 }
        } catch {
            throw ShareRealmError.failBringExclItems
        }
    }
    
    func getExclMemberWithExclItemIdxArr(exclItemIdxArr: [String]) throws -> [RMExclMember] {
        do {
            let realm = try Realm()
            let realmExclMemberArr = realm.objects(RMExclMember.self).where { $0.exclItemIdx.in(exclItemIdxArr) }
            
            return realmExclMemberArr.map { $0 }
        } catch {
            throw ShareRealmError.failBringExclMembers
        }
    }
}
