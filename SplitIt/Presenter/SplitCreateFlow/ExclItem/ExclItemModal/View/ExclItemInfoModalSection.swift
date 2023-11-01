//
//  ExclItemInfoModalSection.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/30.
//

import RxDataSources

struct ExclItemTable {
    var name: String
    var isTarget: Bool
}

struct ExclItemInfoModalSection {
    var isActive: Bool
    var items: [ExclItemTable]
    
    init(isActive: Bool, items: [ExclItemTable]) {
        self.isActive = isActive
        self.items = items
    }
}

extension ExclItemInfoModalSection: SectionModelType {
    
    init(original: ExclItemInfoModalSection, items: [ExclItemTable]) {
        self = original
        self.items = items
    }
}
