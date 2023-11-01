//
//  ExclItemSection.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/30.
//

import RxDataSources

struct ExclItemSection {
    var items: [Item]
    var isActive: Bool
    
    init(items: [String], isAcive: Bool) {
        self.items = items
        self.isActive = isAcive
    }
}

extension ExclItemSection: SectionModelType {
    typealias Item = String
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}

struct ExclItemInfoModalTable {
    var name: [String]
}
