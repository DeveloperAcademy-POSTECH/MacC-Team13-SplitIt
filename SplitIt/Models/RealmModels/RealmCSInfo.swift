//
//  RealmCSInfo.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

class RealmCSInfo: Object {
    @Persisted(primaryKey: true) var csInfoIdx: ObjectId
    @Persisted var title: String
    @Persisted var totalAmount: Int
    @Persisted var splitIdx: String
    
    func update(withCSInfo csInfo: CSInfo) {
        self.csInfoIdx = try! ObjectId(string: csInfo.csInfoIdx)
        self.title = csInfo.title
        self.totalAmount = csInfo.totalAmount
        self.splitIdx = csInfo.splitIdx
    }
}
