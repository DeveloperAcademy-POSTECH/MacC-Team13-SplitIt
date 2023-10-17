//
//  RealmExclMember.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

class RealmExclMember: Object {
    @Persisted(primaryKey: true) var exclMemberIdx: ObjectId
    @Persisted var name: String
    @Persisted var isTarget: Bool
    @Persisted var exclItemIdx: String
    
    func update(withExclMember exclMember: ExclMember) {
        self.exclMemberIdx = try! ObjectId(string: exclMember.exclMemberIdx)
        self.name = exclMember.name
        self.isTarget = exclMember.isTarget
        self.exclItemIdx = exclMember.exclItemIdx
    }
}
