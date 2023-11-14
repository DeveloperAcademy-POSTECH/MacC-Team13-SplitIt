//
//  RMMemberLog.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation
import RealmSwift

class RMMemberLog: Object {
    @Persisted(primaryKey: true) var memberLogIdx: ObjectId
    @Persisted var name: String
}

extension RMMemberLog: LocalConvertibleType {
    func asLocal() -> MemberLog {
        return MemberLog(memberLogIdx: memberLogIdx,
                         name: name)
    }
}

extension MemberLog: RealmRepresentable {
    func asRealm() -> some RMMemberLog {
        return RMMemberLog.build { object in
            object.memberLogIdx = try! ObjectId(string: memberLogIdx)
            object.name = name
        }
    }
}
