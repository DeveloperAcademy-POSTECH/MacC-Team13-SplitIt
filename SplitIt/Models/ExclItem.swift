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
    
    init(exclItemIdx: ObjectId = ObjectId.generate(), name: String, price: Int, csInfoIdx: String) {
        self.exclItemIdx = exclItemIdx.stringValue
        self.name = name
        self.price = price
        self.csInfoIdx = csInfoIdx
    }
}
