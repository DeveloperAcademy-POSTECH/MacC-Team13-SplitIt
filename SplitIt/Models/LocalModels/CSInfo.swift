//
//  CSInfo.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

struct CSInfo {
    var csInfoIdx: String
    var title: String
    var totalAmount: Int
    var splitIdx: String
    
    init(splitIdx: String) {
        self.csInfoIdx = ObjectId.generate().stringValue
        self.title = ""
        self.totalAmount = 0
        self.splitIdx = splitIdx
    }
}

extension CSInfo {
    init(withRealmCSInfo realmCSInfo: RealmCSInfo) {
        self.csInfoIdx = realmCSInfo.csInfoIdx.stringValue
        self.title = realmCSInfo.title
        self.totalAmount = realmCSInfo.totalAmount
        self.splitIdx = realmCSInfo.splitIdx
    }
}
