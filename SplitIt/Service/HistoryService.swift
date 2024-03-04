//
//  HistoryService.swift
//  SplitIt
//
//  Created by Zerom on 2/29/24.
//

import Foundation
import RxSwift

protocol HistoryServiceType {
    func fetchAllSplit() -> Observable<[Split]>
    func getCSInfoWithSplitIdx(splitIdx: String) -> [CSInfo]
    func getCSMemberWithCSInfoIdx(csInfoIdxArr: [String]) -> [CSMember]
}

final class HistoryService: HistoryServiceType {
    
    private var manager: HistoryReamlManagerType
    
    init(historyRealmManager: HistoryReamlManagerType) {
        self.manager = historyRealmManager
    }
    
    func fetchAllSplit() -> Observable<[Split]> {
        return try! manager.getAllSplit()
            .map { $0.map { $0.asLocal() } }
    }
    
    func getCSInfoWithSplitIdx(splitIdx: String) -> [CSInfo] {
        return try! manager.getCSInfoWithSplitIdx(splitIdx: splitIdx)
            .map { $0.asLocal() }
    }
    
    func getCSMemberWithCSInfoIdx(csInfoIdxArr: [String]) -> [CSMember] {
        return try! manager.getCSMemberWithCSInfoIdx(csInfoIdxArr: csInfoIdxArr)
            .map { $0.asLocal() }
    }
}
