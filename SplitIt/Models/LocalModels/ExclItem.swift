//
//  ExclItem.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

struct ExclItem {
    var exclItemIdx: String
    var name: String
    var price: Int
    var csInfoIdx: String
    
    init(csInfoIdx: String, name: String) {
        self.exclItemIdx = ObjectId.generate().stringValue
        self.name = name
        self.price = 0
        self.csInfoIdx = csInfoIdx
    }
}

extension ExclItem: Equatable {
    init(withRealmExclItem realmExclItem: RealmExclItem) {
        self.exclItemIdx = realmExclItem.exclItemIdx.stringValue
        self.name = realmExclItem.name
        self.price = realmExclItem.price
        self.csInfoIdx = realmExclItem.csInfoIdx
    }
}
