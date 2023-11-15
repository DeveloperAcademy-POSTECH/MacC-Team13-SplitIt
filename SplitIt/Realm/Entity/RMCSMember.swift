//
//  RMCSMember.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation
import RealmSwift

class RMCSMember: Object {
    @Persisted(primaryKey: true) var csMemberIdx: ObjectId
    @Persisted var name: String
    @Persisted var csInfoIdx: String
}

extension RMCSMember: LocalConvertibleType {
    func asLocal() -> CSMember {
        return CSMember(csMemberIdx: csMemberIdx,
                        name: name,
                        csInfoIdx: csInfoIdx)
    }
}

extension CSMember: RealmRepresentable {
    func asRealm() -> some RMCSMember {
        return RMCSMember.build { object in
            object.csMemberIdx = try! ObjectId(string: csMemberIdx)
            object.name = name
            object.csInfoIdx = csInfoIdx
        }
    }
}
