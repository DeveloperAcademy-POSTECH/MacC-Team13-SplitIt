//
//  ExclMember.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

struct ExclMember {
    var exclMemberIdx: String
    var name: String
    var isTarget: Bool
    var exclItemIdx: String
    
    init(exclItemIdx: String, name: String) {
        self.exclMemberIdx = ObjectId.generate().stringValue
        self.name = name
        self.isTarget = false
        self.exclItemIdx = exclItemIdx
    }
}

extension ExclMember {
    init(withRealmExclMember realmExclMember: RealmExclMember) {
        self.exclMemberIdx = realmExclMember.exclMemberIdx.stringValue
        self.name = realmExclMember.name
        self.isTarget = realmExclMember.isTarget
        self.exclItemIdx = realmExclMember.exclItemIdx
    }
}
