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
    
    init(exclMemberIdx: ObjectId = ObjectId.generate(), name: String, isTarget: Bool, exclItemIdx: String) {
        self.exclMemberIdx = exclMemberIdx.stringValue
        self.name = name
        self.isTarget = isTarget
        self.exclItemIdx = exclItemIdx
    }
}
