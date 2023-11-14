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
    
    init(splitIdx: ObjectId = ObjectId.generate(), title: String = "", createDate: Date = Date.now) {
        self.splitIdx = splitIdx.stringValue
        self.title = title
        self.createDate = createDate
    }
}
