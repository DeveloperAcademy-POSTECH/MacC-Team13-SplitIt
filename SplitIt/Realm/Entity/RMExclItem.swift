//
//  RMExclItem.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation
import RealmSwift

class RMExclItem: Object {
    @Persisted(primaryKey: true) var exclItemIdx: ObjectId
    @Persisted var name: String
    @Persisted var price: Int
    @Persisted var csInfoIdx: String
}

extension RMExclItem: LocalConvertibleType {
    func asLocal() -> ExclItem {
        return ExclItem(exclItemIdx: exclItemIdx,
                        name: name,
                        price: price,
                        csInfoIdx: csInfoIdx)
    }
}

extension ExclItem: RealmRepresentable {
    func asRealm() -> some RMExclItem {
        return RMExclItem.build { object in
            object.exclItemIdx = try! ObjectId(string: exclItemIdx)
            object.name = name
            object.price = price
            object.csInfoIdx = csInfoIdx
        }
    }
}
