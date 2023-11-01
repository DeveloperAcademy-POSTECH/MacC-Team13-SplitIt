//
//  memberCheck.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/28.
//

import Foundation

struct MemberCheck: Equatable {
    var name: String
    var isCheck: Bool
    
    init(name: String) {
        self.name = name
        self.isCheck = false
    }
    
    init(name: String, isCheck: Bool) {
        self.name = name
        self.isCheck = isCheck
    }
}
