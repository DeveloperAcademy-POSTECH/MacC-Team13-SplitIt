//
//  ExclMemberSection.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import RxDataSources

struct TargetSectionModel {
    var type: TargetSectionType
}

enum TargetSectionType {
    case data(TargetSection)
    case button(TargetSection)
}

struct TargetSection {
    var title: String
    var price: String
    var items: [Target]
    static let button: TargetSection = TargetSection(title: "술", price: "9,000", items: [Target(name: "Button", isTarget: false)])
}

struct Target: IdentifiableType, Equatable {
    let name: String
    let isTarget: Bool
    
    // IdentifiableType
    var identity: String {
        return name
    }
    
    // Equatable
    static func == (lhs: Target, rhs: Target) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension TargetSectionModel: SectionModelType {
    typealias Item = Target // 섹션의 아이템 타입
    var items: [Item] {
        switch type {
        case .data(let targets):
            return targets.items
        case .button(let target):
            return target.items
        }
    }
    
    init(original: TargetSectionModel, items: [Item]) {
        self = original
    }
}


