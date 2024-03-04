//
//  MemberLogService.swift
//  SplitIt
//
//  Created by Zerom on 1/12/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MemberLogServiceType {
    func fetchMemberLog() -> Observable<[MemberLog]>
    func createMemberLog(name: String)
    func deleteMemberLog(memberLogIdx: String)
    func deleteAllMemberLog()
}

class MemberLogService: MemberLogServiceType {
    
    private var manager: MemberLogRealmManagerType
    
    init(memberLogRealManager: MemberLogRealmManagerType) {
        self.manager = memberLogRealManager
    }
    
    func fetchMemberLog() -> Observable<[MemberLog]> {
        return try! manager.getMemberLogAll()
            .map { $0.map { $0.asLocal() } }
    }
    
    func createMemberLog(name: String) {
        manager.updateData(arr: [MemberLog(name: name.trimmingCharacters(in: .whitespacesAndNewlines)).asRealm()])
    }
    
    func deleteMemberLog(memberLogIdx: String) {
        manager.deleteDatas(deleteType: RMMemberLog.self, idxArr: [memberLogIdx])
    }
    
    func deleteAllMemberLog() {
        manager.deleteAllMemberLog()
    }
}
