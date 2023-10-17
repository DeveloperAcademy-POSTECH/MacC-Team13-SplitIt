//
//  Split.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

struct Split {
    var splitIdx: String
    var title: String
    var createDate: Date
    
    init() {
        self.splitIdx = ObjectId.generate().stringValue
        self.title = ""
        self.createDate = Date.now
    }
}

extension Split {
    init(withRealmSplit realmSplit: RealmSplit) {
        self.splitIdx = realmSplit.splitIdx.stringValue
        self.title = realmSplit.title
        self.createDate = realmSplit.createDate
    }
}
