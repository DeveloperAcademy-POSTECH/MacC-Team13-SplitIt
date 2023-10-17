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
    
    init(name: String) {
        self.memberLogIdx = ObjectId.generate().stringValue
        self.name = name
    }
}

extension MemberLog {
    init(withRealmMemberLog realmMemberLog: RealmMemberLog) {
        self.memberLogIdx = realmMemberLog.memberLogIdx.stringValue
        self.name = realmMemberLog.name
    }
}
