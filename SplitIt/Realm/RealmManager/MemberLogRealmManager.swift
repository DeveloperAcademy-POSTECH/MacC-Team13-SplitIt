//
//  MemberLogRealmManager.swift
//  SplitIt
//
//  Created by Zerom on 1/12/24.
//

import Foundation
import RealmSwift
import RxSwift

protocol MemberLogRealmManagerType: RealmManagerType {
    func updateData<T: LocalConvertibleType>(arr: [T])
    func deleteDatas<T: Object & LocalConvertibleType>(deleteType: T.Type, idxArr: [String])
    func getMemberLogAll() throws -> Observable<[RMMemberLog]>
    func deleteAllMemberLog()
}

class MemberLogRealmManager: MemberLogRealmManagerType {
    
    func getMemberLogAll() throws -> Observable<[RMMemberLog]> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let realmMemberLogArr = realm.objects(RMMemberLog.self)
                
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
}
