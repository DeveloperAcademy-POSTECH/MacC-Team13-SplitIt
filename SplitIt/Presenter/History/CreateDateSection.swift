//
//  CreateDateSection.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/19.
//
import Foundation
import RxDataSources

struct CreateDateSection {
    var header: String
    var items: [Item]
    
    init(items: [Split]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        self.header = dateFormatter.string(from: items.first?.createDate ?? Date.now)
        self.items = items
    }
}

extension CreateDateSection: SectionModelType {
    typealias Item = Split
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}
