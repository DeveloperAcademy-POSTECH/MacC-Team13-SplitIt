//
//  LocalConvertibleType.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/14.
//

import Foundation

protocol LocalConvertibleType {
    associatedtype LocalType
    
    func asLocal() -> LocalType
}
