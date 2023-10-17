//
//  CSMember.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

class RealmCSMember: Object {
    @Persisted(primaryKey: true) var csMemberIdx: ObjectId
    @Persisted var name: String
    @Persisted var csInfoIdx: String
    
    func update(withCSMember csMember: CSMember) {
        self.csMemberIdx = try! ObjectId(string: csMember.csMemberIdx)
        self.name = csMember.name
        self.csInfoIdx = csMember.csInfoIdx
    }
}
