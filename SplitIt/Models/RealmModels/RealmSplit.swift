//
//  RealmSplit.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

class RealmSplit: Object {
    @Persisted(primaryKey: true) var splitIdx: ObjectId
    @Persisted var title: String
    @Persisted var createDate: Date
    
    func update(withSplit split: Split) {
        self.splitIdx = try! ObjectId(string: split.splitIdx)
        self.title = split.title
        self.createDate = split.createDate
    }
}
