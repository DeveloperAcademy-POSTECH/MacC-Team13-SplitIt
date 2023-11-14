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
    
    init(csInfoIdx: ObjectId = ObjectId.generate(), title: String, totalAmount: Int = 0, splitIdx: String) {
        self.csInfoIdx = csInfoIdx.stringValue
        self.title = title
        self.totalAmount = totalAmount
        self.splitIdx = splitIdx
    }
}
