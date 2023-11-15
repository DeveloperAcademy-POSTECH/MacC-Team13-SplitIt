//
//  MemberLog.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

struct MemberLog {
    var memberLogIdx: String
    var name: String
    
    init(memberLogIdx: ObjectId = ObjectId.generate(), name: String) {
        self.memberLogIdx = memberLogIdx.stringValue
        self.name = name
    }
}
