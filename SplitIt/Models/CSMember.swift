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
    
    init(csMemberIdx: ObjectId = ObjectId.generate(), name: String, csInfoIdx: String) {
        self.csMemberIdx = csMemberIdx.stringValue
        self.name = name
        self.csInfoIdx = csInfoIdx
    }
}
