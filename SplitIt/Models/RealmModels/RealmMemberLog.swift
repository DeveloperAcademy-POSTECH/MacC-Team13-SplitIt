//
//  RealmMemberLog.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

class RealmMemberLog: Object {
    @Persisted(primaryKey: true) var memberLogIdx: ObjectId
    @Persisted var name: String
    
    func update(withMemerLog memberLog: MemberLog) {
        self.memberLogIdx = try! ObjectId(string: memberLog.memberLogIdx)
        self.name = memberLog.name
    }
}
