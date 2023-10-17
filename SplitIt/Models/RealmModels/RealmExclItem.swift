//
//  RealmExclItem.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/17.
//

import Foundation
import RealmSwift

class RealmExclItem: Object {
    @Persisted(primaryKey: true) var exclItemIdx: ObjectId
    @Persisted var name: String
    @Persisted var price: Int
    @Persisted var csInfoIdx: String
    
    func update(withExclItem exclItem: ExclItem) {
        self.exclItemIdx = try! ObjectId(string: exclItem.exclItemIdx)
        self.name = exclItem.name
        self.price = exclItem.price
        self.csInfoIdx = exclItem.csInfoIdx
    }
}
