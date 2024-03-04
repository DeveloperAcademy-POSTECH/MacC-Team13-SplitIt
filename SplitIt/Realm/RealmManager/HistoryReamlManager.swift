//
//  HistoryReamlManager.swift
//  SplitIt
//
//  Created by Zerom on 2/29/24.
//

import Foundation
import RxSwift
import RealmSwift

enum HistoryReamlError: Error {
    case failGetCSInfoWithSplitIdx
    case failGetCSMemberWithCSInfoIdx
}

protocol HistoryReamlManagerType {
    func getAllSplit() throws -> Observable<[RMSplit]>
    func getCSInfoWithSplitIdx(splitIdx: String) throws -> [RMCSInfo]
    func getCSMemberWithCSInfoIdx(csInfoIdxArr: [String]) throws -> [RMCSMember]
}

final class HistoryReamlManager: HistoryReamlManagerType {
    
    func getAllSplit() throws -> Observable<[RMSplit]> {
        
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let realmMemberLogArr = realm.objects(RMSplit.self)
                
                let notificationToken = realmMemberLogArr.observe { changes in
                    switch changes {
                    case .initial(let logs), .update(let logs, _, _, _):
                        observer.onNext(Array(logs))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    notificationToken.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    func getCSInfoWithSplitIdx(splitIdx: String) throws -> [RMCSInfo] {
        do {
            let realm = try Realm()
            let realmCSInfoArr = realm.objects(RMCSInfo.self).where { $0.splitIdx == splitIdx }
            
            return realmCSInfoArr.map { $0 }
        } catch {
            throw HistoryReamlError.failGetCSInfoWithSplitIdx
        }
    }
    
    func getCSMemberWithCSInfoIdx(csInfoIdxArr: [String]) throws -> [RMCSMember] {
        do {
            let realm = try Realm()
            let realmCSMemberArr = realm.objects(RMCSMember.self).where { $0.csInfoIdx.in(csInfoIdxArr) }
            
            return realmCSMemberArr.map { $0 }
        } catch {
            throw HistoryReamlError.failGetCSMemberWithCSInfoIdx
        }
    }
}
