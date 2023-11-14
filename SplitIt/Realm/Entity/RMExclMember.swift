//
//  RMExclMember.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation
import RealmSwift

class RMExclMember: Object {
    @Persisted(primaryKey: true) var exclMemberIdx: ObjectId
    @Persisted var name: String
    @Persisted var isTarget: Bool
    @Persisted var exclItemIdx: String
}

extension RMExclMember: LocalConvertibleType {
    func asLocal() -> ExclMember {
        return ExclMember(exclMemberIdx: exclMemberIdx,
                          name: name,
                          isTarget: isTarget,
                          exclItemIdx: exclItemIdx)
    }
}

extension ExclMember: RealmRepresentable {
    func asRealm() -> some RMExclMember {
        return RMExclMember.build { object in
            object.exclMemberIdx = try! ObjectId(string: exclMemberIdx)
            object.name = name
            object.isTarget = isTarget
            object.exclItemIdx = exclItemIdx
        }
    }
}
