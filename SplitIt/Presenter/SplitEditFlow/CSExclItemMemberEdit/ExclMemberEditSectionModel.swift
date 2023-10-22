//
//  File.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/22.
//

import Foundation
import RxDataSources

struct ExclMemberEditSectionModel {
    var type: ExclMemberEditSectionType
    
}

enum ExclMemberEditSectionType {
    case data(ExclMemberEditSection)
}

struct ExclMemberEditSection {
    var exclItem: ExclItem
    var items: [ExclMember]
}

extension ExclMemberEditSectionModel: SectionModelType {
    typealias Item = ExclMember
    var items: [Item] {
        switch type {
        case .data(let targets):
            return targets.items
        }
    }
    
    init(original: ExclMemberEditSectionModel, items: [Item]) {
        self = original
    }
}
