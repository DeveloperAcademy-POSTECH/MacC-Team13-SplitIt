//
//  CSMember.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

struct CSMember {
    var csMemberIdx: String
    var name: String
    var csInfoIdx: String
    
    init(csInfoIdx: String, name: String) {
        self.csMemberIdx = ObjectId.generate().stringValue
        self.name = name
        self.csInfoIdx = csInfoIdx
    }
}

extension CSMember {
    init(withRealmCSMember realmCSMember: RealmCSMember) {
        self.csMemberIdx = realmCSMember.csMemberIdx.stringValue
        self.name = realmCSMember.name
        self.csInfoIdx = realmCSMember.csInfoIdx
    }
}
