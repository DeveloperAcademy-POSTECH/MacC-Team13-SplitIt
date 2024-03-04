//
//  ShareService.swift
//  SplitIt
//
//  Created by Zerom on 1/12/24.
//

import Foundation

protocol ShareServiceType {
    var split: Split { get }
    var csInfoArr: [CSInfo] { get }
    var csMemberArr: [CSMember] { get }
    var exclItemArr: [ExclItem] { get }
    var exclMemberArr: [ExclMember] { get }
    
    func fetchCurrentSplitData()
}

class ShareService: ShareServiceType {
    
    private(set) var split: Split = Split()
    private(set) var csInfoArr: [CSInfo] = []
    private(set) var csMemberArr: [CSMember] = []
    private(set) var exclItemArr: [ExclItem] = []
    private(set) var exclMemberArr: [ExclMember] = []
    
    private var currentSplitIdx: String
    private var manager: ShareRealmManagerType
    
    init(currentSplitIdx: String,
         shareRealmManager: ShareRealmManagerType
    ) {
        self.currentSplitIdx = currentSplitIdx
        self.manager = shareRealmManager
        
        fetchCurrentSplitData()
    }
    
    func fetchCurrentSplitData() {
        self.split = try! manager.getSplitWithSplitIdx(splitIdx: currentSplitIdx).asLocal()
        self.csInfoArr = try! manager.getCSInfoWithSplitIdxArr(splitIdx: currentSplitIdx).map { $0.asLocal() }
        self.csMemberArr = try! manager.getCSMemberWithCSInfoIdxArr(csInfoIdxArr: self.csInfoArr.map { $0.csInfoIdx }).map { $0.asLocal() }
        self.exclItemArr = try! manager.getExclItemWithCSInfoIdxArr(csInfoIdxArr: self.csInfoArr.map { $0.csInfoIdx }).map { $0.asLocal() }
        self.exclMemberArr = try! manager.getExclMemberWithExclItemIdxArr(exclItemIdxArr: self.exclItemArr.map { $0.exclItemIdx }).map { $0.asLocal() }
    }
}
