//
//  Realm+.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation
import RealmSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}
