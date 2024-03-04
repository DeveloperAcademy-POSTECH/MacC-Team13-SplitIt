//
//  CreateRealmRepository.swift
//  SplitIt
//
//  Created by Zerom on 1/12/24.
//

import Foundation
import RealmSwift

enum createRealmError: Error {
    case notFoundData
    case notFoundLastCSInfo
    case failBringCount
    case failBringSplit
    case failBringCSMembers
}

protocol CreateRealmManagerType: RealmManagerType {
    func updateData<T: LocalConvertibleType>(arr: [T])
    func deleteDatas<T: Object & LocalConvertibleType>(deleteType: T.Type, idxArr: [String])
    func getCurrentSplit(currentSplitIdx: String) throws -> RMSplit?
    func getCSInfoCount(currentSplitIdx: String) throws -> Int
    func getPreCSMembers(currentSplitIdx: String) throws -> [RMCSMember]
}

final class CreateRealmManager: CreateRealmManagerType {
    
    func getCurrentSplit(currentSplitIdx: String) throws -> RMSplit? {
        do {
            let realm = try Realm()
            let idx = try! ObjectId(string: currentSplitIdx)
            let rmSplit = realm.objects(RMSplit.self).where { $0.splitIdx == idx }
            
            if let rmSplit = rmSplit.first {
                return rmSplit
            } else {
                throw createRealmError.notFoundData
            }
        } catch {
            throw createRealmError.failBringSplit
        }
    }
    
    func getCSInfoCount(currentSplitIdx: String) throws -> Int {
        do {
            let realm = try Realm()
            let realmCSInfoArr = realm.objects(RMCSInfo.self).where { $0.splitIdx == currentSplitIdx }
            
            return realmCSInfoArr.count
        } catch {
            throw createRealmError.failBringCount
        }
    }
    
    func getPreCSMembers(currentSplitIdx: String) throws -> [RMCSMember] {
        do {
            let realm = try Realm()
            let rmCSInfoArr = realm.objects(RMCSInfo.self).where { $0.splitIdx == currentSplitIdx }
            
            guard let lastCSInfo = rmCSInfoArr.last else { throw createRealmError.notFoundLastCSInfo }
            
            let rmCSMemberArr = realm.objects(RMCSMember.self).where { $0.csInfoIdx == lastCSInfo.csInfoIdx.stringValue }
            
            return rmCSMemberArr.map { $0 }
        } catch {
            throw createRealmError.failBringCSMembers
        }
    }
}
