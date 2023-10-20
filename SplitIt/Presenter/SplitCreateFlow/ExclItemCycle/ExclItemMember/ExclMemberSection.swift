//
//  ExclMemberSection.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/19.
//

import RxDataSources

struct ExclMemberSectionModel {
    var type: ExclMemberSectionType
    
    static let addExclItemButton = ExclMemberSectionModel(type: ExclMemberSectionType.button(ExclMemberSection(exclItem: ExclItem(csInfoIdx: "", name: ""), items: [ExclMember(exclItemIdx: "", name: "")])))
}

enum ExclMemberSectionType {
    case data(ExclMemberSection)
    case button(ExclMemberSection)
}

struct ExclMemberSection {
    var exclItem: ExclItem
    var items: [ExclMember]
}

extension ExclMemberSectionModel: SectionModelType {
    typealias Item = ExclMember
    var items: [Item] {
        switch type {
        case .data(let targets):
            return targets.items
        case .button(let target):
            return target.items
        }
    }
    
    init(original: ExclMemberSectionModel, items: [Item]) {
        self = original
    }
}


