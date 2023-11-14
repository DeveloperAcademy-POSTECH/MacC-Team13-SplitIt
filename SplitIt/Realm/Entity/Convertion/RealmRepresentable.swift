//
//  RealmRepresentable.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation

protocol RealmRepresentable {
    associatedtype RealmType: LocalConvertibleType
    
    func asRealm() -> RealmType
}
