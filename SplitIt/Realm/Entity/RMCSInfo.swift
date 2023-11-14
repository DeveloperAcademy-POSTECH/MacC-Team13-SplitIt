//
//  RMCSInfo.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation
import RealmSwift

class RMCSInfo: Object {
    @Persisted(primaryKey: true) var csInfoIdx: ObjectId
    @Persisted var title: String
    @Persisted var totalAmount: Int
    @Persisted var splitIdx: String
}

extension RMCSInfo: LocalConvertibleType {
    func asLocal() -> CSInfo {
        return CSInfo(csInfoIdx: csInfoIdx,
                      title: title,
                      totalAmount: totalAmount,
                      splitIdx: splitIdx)
    }
}

extension CSInfo: RealmRepresentable {
    func asRealm() -> some RMCSInfo {
        return RMCSInfo.build { object in
            object.csInfoIdx = try! ObjectId(string: csInfoIdx)
            object.title = title
            object.totalAmount = totalAmount
            object.splitIdx = splitIdx
        }
    }
}
