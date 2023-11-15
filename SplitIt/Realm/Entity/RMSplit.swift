//
//  RMSplit.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation
import RealmSwift

class RMSplit: Object {
    @Persisted(primaryKey: true) var splitIdx: ObjectId
    @Persisted var title: String
    @Persisted var createDate: Date
}

extension RMSplit: LocalConvertibleType {
    func asLocal() -> Split {
        return Split(splitIdx: splitIdx,
                     title: title,
                     createDate: createDate)
    }
}

extension Split: RealmRepresentable {
    func asRealm() -> some RMSplit {
        return RMSplit.build { object in
            object.splitIdx = try! ObjectId(string: splitIdx)
            object.title = title
            object.createDate = createDate
        }
    }
}
